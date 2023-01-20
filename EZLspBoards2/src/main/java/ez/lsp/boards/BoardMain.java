/*
 * BoardMain : Test Sample Code
 */
package ez.lsp.boards;

import java.sql.Connection;
import java.sql.PreparedStatement;

import ez.lsp.databases.DBConnectionMgr;

public class BoardMain {
	final static int MAX_TEXTDATA = 1000;
	
	private DBConnectionMgr pool;

	public BoardMain() {
		try {
			pool = DBConnectionMgr.getInstance();
		} 
		catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 페이징 및 블럭 테스트를 위한 게시물 저장 메소드 
	public int insertTestData() {
		Connection con = null;
		PreparedStatement stmt = null;
		String sql = null;
		try {
			con  = pool.getConnection();
			sql  = "insert into ezlspboards (num,name,subject,content,ref,pos,depth,regdate,pass,count,ip,filename,filesize) ";
			sql += "values(ezlspboards_seq.nextval, ?, ?, ?, 0, 0, 0, sysdate, '1111', 0, '127.0.0.1', null, 0)";
			
			stmt = con.prepareStatement(sql);
			for (int i = 0; i < MAX_TEXTDATA; i++) {
				String name = String.format("[%d]", i);
				String subject = String.format("제목:%d", i);
				String content = String.format("내용:%d", i);
				stmt.setString(1, name);
				stmt.setString(2, subject);
				stmt.setString(3, content);
				stmt.executeUpdate();
			}
			
			return MAX_TEXTDATA;
		} 
		catch (Exception e) {
			e.printStackTrace();
		} 
		finally {
			pool.freeConnection(con, stmt);
		}
		
		return 0;
	}
	
	// main
	public static void main(String[] args) {
		BoardMain main = new BoardMain();
		System.out.println("SUCCESS : insert row=" + main.insertTestData());
	}
	
}