<%@page import="secure.Security"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="java.io.File"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String saveDirectory = application.getRealPath("/upload");
	int maxPostSize = 20 * 1024 * 1024;
	System.out.println(saveDirectory);
	
	// 폴더 생성
	File folder = new File(saveDirectory);  
	if(!folder.exists()) folder.mkdir();
	
	//-------------------------------
	// 원본 파일 업로드
	//-------------------------------
	MultipartRequest mr = null;
	try {
		mr = new MultipartRequest(request, saveDirectory, maxPostSize, "UTF-8", new DefaultFileRenamePolicy());
	}
	catch(Exception e) {
		System.err.println("Exception[MultipartRequest] : " + e.getMessage());
	}
	
	String fileName = mr.getFilesystemName("file");
	
	// 브라우저 별 한글 파일명 깨짐 방지
	String client = request.getHeader("User-Agent");
	if(client.indexOf("WOW64") == -1) {
		fileName = new String(fileName.getBytes("utf-8"), "ISO-8859-1");
	}
	else {
		fileName = new String(fileName.getBytes("KSC5601"), "ISO-8859-1");
	}
	
	//-------------------------------
	// 파일 암호화 or 복호화 시작
	//-------------------------------
	File outputFile = null;
	String password = mr.getParameter("password");
	
	// 암호화
	String category = mr.getParameter("category");
	if(category.equals("encrypt")) {
		System.out.println("파일 암호화 시작");
		outputFile = new File(saveDirectory, "encrypted_"+fileName);
		Security.encrypt(mr.getFile("file"), outputFile, password);
	}
	// 복호화
	else if(category.equals("decrypt")) {
		System.out.println("파일 복호화 시작");
		outputFile = new File(saveDirectory, "decrypted_"+fileName);
		Security.decrypt(mr.getFile("file"), outputFile, password);
	}
	
	//-------------------------------
	// 파일 다운로드
	//-------------------------------
	try {
		InputStream inputStream = new FileInputStream(outputFile);
		response.reset();
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + outputFile.getName() + "\"");
		response.setHeader("Content-Length", outputFile.length() + "");
		
		// 출력 스트림을 초기화
		out.clear();
		
		OutputStream outStream = response.getOutputStream();
		byte[] b = new byte[1024];
		int readBuffer = 0;
		while((readBuffer = inputStream.read(b)) != -1) {
			outStream.write(b, 0, readBuffer);
		}
		
		outStream.close();
		inputStream.close();
	}
	catch(Exception e) {
		System.err.println("Exception[FileStream] : " + e.getMessage());
	}
	
%>