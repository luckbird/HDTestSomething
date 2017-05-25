//
//  BC_RSA.m
//  rsa
//
//  Created by 斌 on 13-9-31.
//  Copyright (c) 2013年 斌. All rights reserved.
//

#import "BC_RSA.h"
#import "GTMBase64.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation BC_RSA

#define kChosenDigestLength CC_SHA1_DIGEST_LENGTH
static SecKeyRef privateKeyRef;


+(SecKeyRef)setPrivateKey:(NSString*)path password:(NSString*)pwd{
    
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init]; // Set the private key query dictionary.
    [options setObject:pwd forKey:(__bridge id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) data, (__bridge CFDictionaryRef)options, &items);
    if (securityError!=noErr) {
        return nil ;
    }
    CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
    SecIdentityRef identityApp =(SecIdentityRef)CFDictionaryGetValue(identityDict,kSecImportItemIdentity);
    SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);//
    return privateKeyRef;
}

+ (NSString *)signTheDataSHA1WithRSA:(NSString *)plainText
{
    uint8_t* signedBytes = NULL;
    size_t signedBytesSize = 0;
    OSStatus sanityCheck = noErr;
    NSData* signedHash = nil;
    
    signedBytesSize = SecKeyGetBlockSize(privateKeyRef);
    
    NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    signedBytes = malloc( signedBytesSize * sizeof(uint8_t) ); // Malloc a buffer to hold signature.
    memset((void *)signedBytes, 0x0, signedBytesSize);
    
    sanityCheck = SecKeyRawSign(privateKeyRef,
                                kSecPaddingPKCS1SHA1,
                                (const uint8_t *)[[self getHashBytes:plainTextBytes] bytes],
                                kChosenDigestLength,
                                (uint8_t *)signedBytes,
                                &signedBytesSize);
    
    
    if (sanityCheck == errSecSuccess)
    {
        signedHash = [NSData dataWithBytes:(const void *)signedBytes length:(NSUInteger)signedBytesSize];
        
    }else{
        
        NSLog(@"【error!!】 err code:%d", (int)sanityCheck);
        return  nil;
    }
    
    if (signedBytes)
    {
        free(signedBytes);
    }

    NSString *signatureResult=[NSString stringWithFormat:@"%@",[GTMBase64 encodeBase64Data:signedHash]];
    return signatureResult;
}

+ (NSData *)getHashBytes:(NSData *)plainText {
    CC_SHA1_CTX ctx;
    uint8_t * hashBytes = NULL;
    NSData * hash = nil;
    
    // Malloc a buffer to hold hash.
    hashBytes = malloc( kChosenDigestLength * sizeof(uint8_t) );
    memset((void *)hashBytes, 0x0, kChosenDigestLength);
    // Initialize the context.
    CC_SHA1_Init(&ctx);
    // Perform the hash.
    CC_SHA1_Update(&ctx, (void *)[plainText bytes], [plainText length]);
    // Finalize the output.
    CC_SHA1_Final(hashBytes, &ctx);
    
    // Build up the SHA1 blob.
    hash = [NSData dataWithBytes:(const void *)hashBytes length:(NSUInteger)kChosenDigestLength];
    if (hashBytes) free(hashBytes);
    
    return hash;
}


+(NSString *)RSAEncrypotoTheData:(NSString *)plainText
{
    
    SecKeyRef publicKey=nil;
    publicKey=[self getPublicKey];
    size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
    uint8_t *cipherBuffer = NULL;
    
    cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0*0, cipherBufferSize);
    
    NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    int blockSize = cipherBufferSize-11;  // 这个地方比较重要是加密问组长度
    int numBlock = (int)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i=0; i<numBlock; i++) {
        int bufferSize = MIN(blockSize,[plainTextBytes length]-i*blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(publicKey,
                                        kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        if (status == noErr)
        {
            NSData *encryptedBytes = [[[NSData alloc]
                                       initWithBytes:(const void *)cipherBuffer
                                       length:cipherBufferSize] autorelease];
            [encryptedData appendData:encryptedBytes];
        }
        else
        {
            return nil;
        }
    }
    if (cipherBuffer)
    {
        free(cipherBuffer);
    }
    
    NSString *encrypotoResult=[NSString stringWithFormat:@"%@",[GTMBase64 encodeBase64Data:encryptedData]];
    return encrypotoResult;
}

+(SecKeyRef)getPublicKey{
    NSString *certPath;
    certPath = [[NSBundle mainBundle] pathForResource:@"u.ysepay.com_new" ofType:@"cer"];
    
    SecCertificateRef myCertificate = nil;
    NSData *certificateData = [[NSData alloc] initWithContentsOfFile:certPath];
    myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
    SecTrustRef myTrust;
    OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
    SecTrustResultType trustResult;
    if (status == noErr) {
        status = SecTrustEvaluate(myTrust, &trustResult);
    }
    return SecTrustCopyPublicKey(myTrust);
}



@end
