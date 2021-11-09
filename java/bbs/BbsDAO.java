package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	private Connection conn;
	// 데이터베이스 접근에 있어서 마찰이 일어나지 않게 PreparedStatement을 제거
	// private PreparedStatement pstmt;
	private ResultSet rs;
	
	public BbsDAO() {
		try {
			// dbURL 이부분이 다름 -> 틀리면 데이터베이스 오류남!!
			String dbURL = "jdbc:mysql://localhost:3307/bbs?serverTimezone=UTC";
			String dbID = "root";
			String dbPassword = "1234";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	// 현재의 시간을 가져오는 함수
	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			// SQL문을 실행준비 단계로 만들어주는 것.
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			// 실제로 실행했을 때 나오는 결과를 가져오는 것.
			rs = pstmt.executeQuery();
			if (rs.next()) {
				// 1을 해서 현재 그 날짜를 그대로 반환
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";  // 데이터 베이스 오류
	}
	
	// 게시판 번호를 가져오는 함수
	public int getNext() {
		String SQL = "SELECT bbsID FROM bbs ORDER BY bbsID DESC";
		try {
			// SQL문을 실행준비 단계로 만들어주는 것.
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			// 실제로 실행했을 때 나오는 결과를 가져오는 것.
			rs = pstmt.executeQuery();
			if (rs.next()) {
				// 1을 해서 현재 그 날짜를 그대로 반환
				return rs.getInt(1) + 1;
			}
			return 1; // 첫 번째 게시글인 경우
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;  // 데이터 베이스 오류
	}
	
	// 쓰는 함수를 구현
	public int write(String bbsTitle, String userID, String bbsContent) {
		String SQL = "INSERT INTO bbs VALUES(?, ?, ?, ?, ?, ?)";
		try {
			// SQL문을 실행준비 단계로 만들어주는 것.
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			//pstmt 에다가 하나씩 값을 넣어주기
			pstmt.setInt(1, getNext());
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);  // 삭제가 안된 상태니까 1을 넣어주는것.
			
			// insert 성공할 경우 0이상의 값을 반환
			return pstmt.executeUpdate();
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;  // 데이터 베이스 오류
	}
	
	// 특정 리스트를 arraylist로서 가져오게 만듬
	// 특정 페이지에 따른 10개의 게시글 가져오기
	public ArrayList<Bbs> getList(int pageNumber) {
		String SQL = "SELECT * FROM bbs WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		// Bbs클래스에서 나오는 인스턴스를 보관하는 arrylist 생성
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			// SQL문을 실행준비 단계로 만들어주는 것.
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			// 실제로 실행했을 때 나오는 결과를 가져오는 것.
			rs = pstmt.executeQuery();
			// 결과가 나올때 마다
			while (rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				// 리스트에 해당 인스턴스를 반환
				list.add(bbs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;  // 데이터 베이스 오류
	}
	
	
	// 페이징 처리를 위해 존재
	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM bbs WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		
		try {
			// SQL문을 실행준비 단계로 만들어주는 것.
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			// 실제로 실행했을 때 나오는 결과를 가져오는 것.
			rs = pstmt.executeQuery();
			// 결과가 하나라도 존재 한다면 다음 페이지로 넘어갈 수 있다고 보여준다.
			if (rs.next()) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;  // 그렇지 않다면 거짓
	}
	
	
	// 하나의 함수를 가져오는 함수
	public Bbs getBbs(int bbsID){
		String SQL = "SELECT * FROM bbs WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,bbsID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				return bbs;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	// 게시글 하나를 수정하는 함수
	public int update(int bbsID, String bbsTItle, String bbsContent) {
		String SQL = "UPDATE bbs SET bbsTitle=?, bbsContent=? WHERE bbsID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, bbsTItle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터 베이스 오류
	}
	
	// 게시판 하나를 삭제하나를 삭제하는 함수
	public int delete(int bbsID) {
		String SQL = "UPDATE bbs SET bbsAvailable = 0 WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터 베이스 오류
	}
}

