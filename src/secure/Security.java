package secure;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;

import javax.crypto.Cipher;
import javax.crypto.CipherOutputStream;
import javax.crypto.spec.SecretKeySpec;

public class Security {
	
	// 암호화
	public static void encrypt(File inputFile, File outputFile, String password) throws Exception {
		byte[] pw = convertStringTo16Length(password);
		
		SecretKeySpec key = new SecretKeySpec(pw, "AES");
		Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
		cipher.init(Cipher.ENCRYPT_MODE, key);
		
		InputStream input = null;
		OutputStream output = null;
		try {
			input = new BufferedInputStream(new FileInputStream(inputFile));
			output = new CipherOutputStream(new BufferedOutputStream(new FileOutputStream(outputFile)), cipher);
			int size = 0;
			byte[] buffer = new byte[1024];
			while((size = input.read(buffer)) != -1) {
				output.write(buffer, 0, size);
			}
		}
		catch(Exception e) {
			System.err.println("Exception[Encryption] : " + e.getLocalizedMessage());
		}
		finally {
			try {
				if(output != null) output.close();
				if(input != null) input.close();
			}
			catch(Exception e) {
				System.err.println("Exception[close] : " +  e.getLocalizedMessage());
			}
			System.out.println("파일 암호화 종료");
		}
	}
	
	// 복호화
	public static void decrypt(File encryptFile, File outputFile, String password) throws Exception {
		byte[] pw = convertStringTo16Length(password);
		
		SecretKeySpec key = new SecretKeySpec(pw, "AES");
		Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
		cipher.init(Cipher.DECRYPT_MODE, key);
		
		InputStream input = null;
		OutputStream output = null;
		
		try {
			input = new BufferedInputStream(new FileInputStream(encryptFile));
			output = new CipherOutputStream(new BufferedOutputStream(new FileOutputStream(outputFile)), cipher);
			int size = 0;
			byte[] buffer = new byte[1024];
			while((size = input.read(buffer)) != -1) {
				output.write(buffer, 0, size);
			}
		}
		catch(Exception e) {
			System.err.println("Exception[Decryption] : " + e.getLocalizedMessage());
		}
		finally {
			try {
				if(output != null) output.close();
				if(input != null) input.close();
			}
			catch(Exception e) {
				System.err.println("Exception[close] : " +  e.getLocalizedMessage());
			}
			System.out.println("파일 복호화 종료");
		}
	}
	
	// 16byte 미만이면 0으로 채우고 16byte 초과면 자릅니다.
	static byte[] convertStringTo16Length(String str) {
		byte[] b = new byte[16]; 
		for(int i = 0; i < 16; i++) {
			if(i < str.getBytes().length)
				b[i] = str.getBytes()[i];
			else b[i] = 0;
		}
		
		return b;
	}
}
