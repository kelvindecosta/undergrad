/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.kelvin;


import java.security.*;
import javax.crypto.*;
/**
 *
 * @author Admin
 */
public class PKC {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws Exception {
        // Create cipher object
        Cipher c = Cipher.getInstance("RSA/ECB/PKCS1Padding");

        // Generate Key Pair
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("RSA");
        kpg.initialize(2048);
        KeyPair kp = kpg.generateKeyPair();
        
        // Perform encyrpyion
        System.out.println("PERFORMING ENCRYPTION");
        byte[] pBytes = "SOC Lab is on time!".getBytes();
        System.out.println("\tPlain Text : " + new String(pBytes));
        c.init(Cipher.ENCRYPT_MODE, kp.getPublic());
        byte[] cBytes = c.doFinal(pBytes);
        System.out.println("\tCipher Text : " + new String(cBytes) + "\n");
        
        // Perform decryption
        System.out.println("PERFORMING DECRYPTION");
        c.init(Cipher.DECRYPT_MODE, kp.getPrivate());
        byte[] dBytes = c.doFinal(cBytes);
        System.out.println("\tDecrytpion : " + new String(dBytes) + "\n");
        
        // Performing Digital Signature
        System.out.println("PERFORMING DIGITAL SIGNATURE");
        Signature sign = Signature.getInstance("SHA256withRSA");
        sign.initSign(kp.getPrivate());
        byte[] mBytes = "SOC Lab is interesting".getBytes();
        System.out.println("\tMessage Text : " + new String(mBytes));
        sign.update(mBytes);
        byte[] s1Bytes = sign.sign();
        System.out.println("\tSignature : " + new String(s1Bytes));
       
        // Verifying signature
        sign.initVerify(kp.getPublic());
        sign.update(mBytes);
        System.out.println("\tVerified : " + (sign.verify(s1Bytes) ? "YES" : "NO"));
        sign.update(pBytes);
        System.out.println("\tVerified : " + (sign.verify(s1Bytes) ? "YES" : "NO"));
        
//        // Performing Digital Signature from Scratch
//        System.out.println("PERFORMING DIGITAL SIGNATURE (SCRACTH)");
//        MessageDigest d = MessageDigest.getInstance("SHA256");
//        byte[] d1Bytes = d.digest(mBytes);
//        c.init(Cipher.ENCRYPT_MODE, kp.getPrivate());
//        byte[] s2 = c.doFinal(d1Bytes);

    }
    
    public static KeyPair generateKeyPair() throws NoSuchAlgorithmException, NoSuchProviderException {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("RSA");
        kpg.initialize(2048);
        return kpg.generateKeyPair();
    }
}
