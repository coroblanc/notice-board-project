package ez.lsp.boards;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import ez.lsp.boards.oracle.BoardDAO;

@WebServlet("/boardPost")
public class BoardPostServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		BoardDAO bMgr = new BoardDAO();
		bMgr.insertBoard(request);
		response.sendRedirect("list.jsp");
	}
}