package kh.cocoa.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import kh.cocoa.dto.BoardDTO;
import kh.cocoa.dto.EmployeeDTO;
import kh.cocoa.dto.FilesDTO;
import kh.cocoa.dto.SidebarViewDTO;
import kh.cocoa.service.FilesService;
import kh.cocoa.service.NotificationBoardService;
import kh.cocoa.service.SidebarService;
import kh.cocoa.statics.Configurator;

@Controller
@RequestMapping("/noBoard")
public class NotificationBoardController {

	@Autowired
	private NotificationBoardService nservice;
	
	@Autowired
	private FilesService fservice;

	@Autowired
	private SidebarService sservice;
	@Autowired
	private HttpSession session;
	//게시판
	@RequestMapping("notificationBoardList.no") 
	public String notificationBoardList(String type, String mid_name,BoardDTO dto,FilesDTO fdto,int menu_seq, String cpage,Model model) { 
		System.out.println("type은? "+type);
		System.out.println("mid_name은? "+mid_name);
		//게시글 이름& 타입 가져오기
		SidebarViewDTO sviewDTO  = sservice.selectInfor(menu_seq);
		 mid_name = sviewDTO.getMid_name();
		 type = sviewDTO.getType();
		EmployeeDTO loginDTO = (EmployeeDTO)session.getAttribute("loginDTO");
		
		int writer_code = (Integer)loginDTO.getCode();
		System.out.println("여기서 직원 코드는?" +writer_code);
		int dept_code = (Integer)loginDTO.getDept_code();
		System.out.println("여기서 부서 코드는?" +dept_code);
		
		if(cpage==null) {cpage="1";} 
		//게시글 불러오기
		List<BoardDTO> list = new ArrayList<BoardDTO>();
		list = nservice.getNotificationBoardListCpage(cpage,menu_seq);
		System.out.println(list);
		//시작 & 끝 페이지 불러오기
		String navi = nservice.getNavi(type,Integer.parseInt(cpage),menu_seq);
		
		model.addAttribute("navi",navi);
		model.addAttribute("list",list);
		model.addAttribute("dept_code",dept_code);
		model.addAttribute("cpage",cpage);
		model.addAttribute("menu_seq",menu_seq);
		model.addAttribute("mid_name",mid_name);

		if(menu_seq==1) { //게시판 seq가 1인 경우 - 회사소식
			
			return "community/notificationBoardList"; 
		}else if(menu_seq==2||type.contentEquals("List")) {//게시판 seq가 2인 경우 - 자유게시판

			return "community/cocoaWorksBoardList"; 
			
		}else if(menu_seq==3||type.contentEquals("Album")) {//게시판 seq가 3인 경우 - 앨범게시판

			//게시글 불러오기 (사진제외)
			List<BoardDTO> albumList = new ArrayList<BoardDTO>();
			albumList = nservice.getAlbumBoardListCpage(cpage,menu_seq);
			model.addAttribute("albumList",albumList);
			model.addAttribute("cpage",cpage);
			model.addAttribute("menu_seq",menu_seq);
			model.addAttribute("mid_name",mid_name);
			
			return "community/albumBoardList";
		}
		return "index";
	}

	//게시글 읽기
	@RequestMapping("notificationBoardRead.no")
	public String notificationBoardRead(int menu_seq,String cpage,BoardDTO dto,FilesDTO fdto, Model model) {
		System.out.println("게시판 번호?"+menu_seq);
		

		//게시글 이름& 타입 가져오기
		SidebarViewDTO sviewDTO  = sservice.selectInfor(menu_seq);
		String mid_name = sviewDTO.getMid_name();
		String type = sviewDTO.getType();
		
		EmployeeDTO loginDTO = (EmployeeDTO)session.getAttribute("loginDTO");

		int writer_code = (Integer)loginDTO.getCode();
		//로그인한 정보의 code를 board DTO writer_code에 넣어주기
		dto.setWriter_code(writer_code);
		
		
		if(cpage==null) {cpage="1";}
		//seq로 게시글 수 확인
		int isExistReadPage = nservice.isExistReadPage(dto.getMenu_seq());
		if(isExistReadPage>0) {
			//게시글에 업로드된 파일 갯수 확인
			int isExistUploadFile = fservice.isExistUploadFile(fdto);

			//게시글에 업로드된 첨부파일 리스트 불러오기
			List<FilesDTO> fileList = fservice.getFilesBySeq(fdto);

			//조회수 올리기
			nservice.notificationBoardViewCount(dto);

			//seq으로 게시글 내용 가져와서 내용 뿌려주기
			BoardDTO bdto = nservice.notificationBoardContentsSelect(dto);
			
			//게시글 작성자와 로그인한 사람이 동일한지 확인하고 수정 삭제 권환주기
			int checkWriter = nservice.checkWriter(dto);

			model.addAttribute("dto",bdto);
			model.addAttribute("checkWriter",checkWriter);
			model.addAttribute("cpage",cpage);
			model.addAttribute("seq",dto.getSeq());
			model.addAttribute("fileList", fileList);
			model.addAttribute("fileCount",isExistUploadFile);
			model.addAttribute("s",sviewDTO);
		}

		if(dto.getMenu_seq()==1) { //게시판 seq가 1인 경우 - 회사소식
			return "community/notificationBoardRead";
		}else if(dto.getMenu_seq()==2||type.contentEquals("List")) { //게시판 seq가 2인 경우 - 자유게시판
			return "community/cocoaWorksBoardRead";
		}else if(dto.getMenu_seq()==3||type.contentEquals("Album")) {//게시판 seq가 3인 경우 - 앨범게시판
			return "community/albumBoardRead";
		}
		return "index";
	}
	//게시글 검색
		@GetMapping("notificationBoardSearch.no")
		public String notificationBoardSearch(String cpage, String search,String searchBy,int menu_seq, Model model) {

			EmployeeDTO loginDTO = (EmployeeDTO)session.getAttribute("loginDTO");
			int dept_code = (Integer)loginDTO.getDept_code();
			//게시글 이름& 타입 가져오기
			SidebarViewDTO sviewDTO  = sservice.selectInfor(menu_seq);
			String mid_name = sviewDTO.getMid_name();
			String type = sviewDTO.getType();
			if(cpage==null) {cpage = "1";}
			List<BoardDTO> list = nservice.notificationBoardListBySearch(search,searchBy,menu_seq,Integer.parseInt(cpage));
			int getSearchCount = nservice.getSearchCount(search,searchBy,menu_seq);
			System.out.println("컨트롤러에서 갯수" + getSearchCount);
			String navi= nservice.notificationBoardSearchNavi(menu_seq,Integer.parseInt(cpage), searchBy,search,getSearchCount);
			
			model.addAttribute("list", list);
			model.addAttribute("navi", navi);
			model.addAttribute("dept_code",dept_code);
			model.addAttribute("cpage", cpage);
			model.addAttribute("menu_seq",menu_seq);
			model.addAttribute("search", search);
			model.addAttribute("mid_name", mid_name);
			model.addAttribute("type", type);
			
			if(menu_seq==1) { //게시판 seq가 1인 경우 - 회사소식
				return "community/notificationBoardList"; 

			}else if(menu_seq==2||type.contentEquals("List")) {//게시판 seq가 2인 경우 - 자유게시판
				return "community/cocoaWorksBoardList"; 
			}else if(menu_seq==3||type.contentEquals("Album")) {//게시판 seq가 3인 경우 - 앨범게시판
				List<BoardDTO> albumList = nservice.getAlbumBoardListSearch(search,searchBy,menu_seq,Integer.parseInt(cpage));
				model.addAttribute("albumList", albumList);
				model.addAttribute("cpage", cpage);
				model.addAttribute("search", search);
				return "community/albumBoardList";
			}
			return "index";
		}
	
		//게시글 작성 페이지 이동
		@RequestMapping("notificationBoardCreate.no")
		public String notificationBoardCreate(String cpage,int menu_seq, Model model) {
			EmployeeDTO loginDTO = (EmployeeDTO)session.getAttribute("loginDTO");
			System.out.println("로그인 아이디값 "+loginDTO);
			
			if(cpage==null) {cpage="1";}

			//게시글 이름& 타입 가져오기
			SidebarViewDTO sviewDTO  = sservice.selectInfor(menu_seq);
			String mid_name = sviewDTO.getMid_name();
			String type = sviewDTO.getType();
				
			model.addAttribute("cpage",cpage);
			model.addAttribute("menu_seq",menu_seq);
			model.addAttribute("mid_name",mid_name);
			model.addAttribute("type",type);

			if(menu_seq==1) { //게시판 seq가 1인 경우 - 회사소식
				return "community/notificationBoardCreate";

			}else if(menu_seq==2||type.contentEquals("List")) {//게시판 seq가 2인 경우 - 자유게시판
				return "community/cocoaWorksBoardCreate"; 
			}else if(menu_seq==3||type.contentEquals("Album")) {//게시판 seq가 3인 경우 - 앨범게시판
				return "community/albumBoardCreate";
			}
			return "index";
		}
		//게시글 작성 완료
		@RequestMapping("notificationBoardCreateDone.no")
		public String notificationBoardCreateDone(BoardDTO bdto, int menu_seq,List<MultipartFile> file,Model model) throws Exception {
			EmployeeDTO loginDTO = (EmployeeDTO)session.getAttribute("loginDTO");
			bdto.setTitle(Configurator.XssReplace(bdto.getTitle()));
			bdto.setContents(Configurator.XssReplace(bdto.getContents()));
			//게시글 이름& 타입 가져오기
			SidebarViewDTO sviewDTO  = sservice.selectInfor(menu_seq);
			String type = sviewDTO.getType();
			String mid_name = sviewDTO.getMid_name();
			int writer_code = (Integer)loginDTO.getCode();
			//로그인한 정보의 code를 board DTO writer_code에 넣어주기
			bdto.setWriter_code(writer_code);
			
			//board & files seq값 동일하게 맞추기
			int noBoard_seq = nservice.noBoardSelectSeq();
	
			//글 작성 
			int done = nservice.notificationBoardCreateDone(noBoard_seq,bdto,menu_seq);
			System.out.println("글작성 결과는?"+done);
			if(file!=null) { //파일이 있을 때
				//파일 업로드 할 갯수 확인
				int filesCount = 0;
				for (MultipartFile mf : file) {
					if (!mf.isEmpty()) {
						filesCount += 1;
					}
				}
				//submit을 눌렀을 때, 업로드할 file이 있는 경우만 files에 업로드 (최대 10개)
				if(filesCount<11){
					if (!file.get(0).isEmpty()) { //파일추가 없이 글쓰기 
						String fileRoot = Configurator.boardFileRootC; //파일 저장할 경로
						File filesPath = new File(fileRoot);
						//폴더 없으면 만들기
						if(!filesPath.exists()) {filesPath.mkdir();}
	
	
						for (MultipartFile mf : file) {
							String oriName = mf.getOriginalFilename();
							String uid = UUID.randomUUID().toString().replaceAll("-", "");
							String savedName = uid + "-" + oriName;
							// dto에 값을 담아서 db에 전송
							FilesDTO fdto = new FilesDTO(0, oriName, savedName,null, noBoard_seq,0,0,0);
	
							int result = fservice.uploadFiles(noBoard_seq,fdto);
							if (result > 0) {
								File targetLoc = new File(filesPath.getAbsolutePath() + "/" + savedName);
								FileCopyUtils.copy(mf.getBytes(), targetLoc);
							}
						}
					}
				}
			}
			model.addAttribute("cpage", 1);
			model.addAttribute("menu_seq",menu_seq);
			model.addAttribute("mid_name",mid_name);
			return "redirect:/noBoard/notificationBoardList.no?menu_seq="+menu_seq+"&type="+type+"&mid_name"+mid_name;
		}
	
	
		//게시글 수정
		@RequestMapping("notificationBoardModify.no")
		public String notificationBoardModify(int menu_seq,BoardDTO dto,FilesDTO fdto,int cpage,Model model) {
			//게시글 이름& 타입 가져오기
			SidebarViewDTO sviewDTO  = sservice.selectInfor(menu_seq);
			String mid_name = sviewDTO.getMid_name();
			String type = sviewDTO.getType();
			//seq으로 제목,작성자,날짜,내용 가져오기
			BoardDTO bdto = nservice.notificationBoardContentsSelect(dto);
			System.out.println("왜 안되니?"+bdto);
			//게시글에 업로드된 첨부파일 리스트 불러오기
			List<FilesDTO> fileList = fservice.getFilesBySeq(fdto);
			model.addAttribute("dto",bdto);
			model.addAttribute("cpage",cpage);
			model.addAttribute("seq",dto.getSeq());
			model.addAttribute("fileList", fileList);
			model.addAttribute("menu_seq",menu_seq);
			model.addAttribute("mid_name",mid_name);
			model.addAttribute("type",type);
			
			if(dto.getMenu_seq()==1) { //게시판 seq가 1인 경우 - 회사소식
				return "community/notificationBoardModify";

			}else if(dto.getMenu_seq()==2||type.contentEquals("List")) {//게시판 seq가 2인 경우 - 자유게시판
				return "community/cocoaWorksBoardModify"; 
			}else if(menu_seq==3||type.contentEquals("Album")) {//게시판 seq가 3인 경우 - 앨범게시판
				return "community/albumBoardModify";
			}
			return "index";
		}
		//게시글 수정 완료
		@RequestMapping("notificationBoardModifyDone.no")
		public String notificationBoardModifyDone(int[] delArr,int menu_seq,BoardDTO dto,FilesDTO fdto, List<MultipartFile> file,Model model) throws IOException {
			System.out.println("게시글 번호는 ?"+dto.getSeq());
			dto.setTitle(Configurator.XssReplace(dto.getTitle()));
			dto.setContents(Configurator.XssReplace(dto.getContents()));
			//게시글 이름& 타입 가져오기
			SidebarViewDTO sviewDTO  = sservice.selectInfor(menu_seq);
			String mid_name = sviewDTO.getMid_name();
			System.out.println("게시판 이름ㅇㅡㅡ ?"+mid_name);
			String type = sviewDTO.getType();
			//수정된 글 업로드
			nservice.notificationBoardContentsModify(dto);
	
			//seq로 게시글 수 확인
			int isExistReadPage = nservice.isExistReadPage(dto.getMenu_seq());
			if(isExistReadPage>0) {
				//게시글에 업로드된 파일 갯수 확인
				int isExistUploadFile = fservice.isExistUploadFile(fdto);
	
				//게시글에 업로드된 첨부파일 리스트 불러오기
				List<FilesDTO> fileList = fservice.getFilesBySeq(fdto);
	
				/*------------------파일 수정--------------*/
				//파일 삭제 - 파일의 seq로 삭제
				if (delArr != null) {
					System.out.println("선택된 갯수? "+delArr.length);
					int fileDelResult = 0;
					for (int i = 0; i < delArr.length; i++) {
						fileDelResult += fservice.deleteNotificationBoardFiles(delArr[i]);
					}
					System.out.println("파일 삭제 :" +fileDelResult);
				}
				//파일 추가
				if(file!=null) {
	
					if (!file.get(0).isEmpty()) { //파일추가 없이 글쓰기 
						String fileRoot = Configurator.boardFileRootC; //파일 저장할 경로
						File filesPath = new File(fileRoot);
						//폴더 없으면 만들기
						if(!filesPath.exists()) {filesPath.mkdir();}
						for (MultipartFile mf : file) {
							String oriName = mf.getOriginalFilename();
							String uid = UUID.randomUUID().toString().replaceAll("-", "");
							String savedName = uid + "-" + oriName;
							// dto에 값을 담아서 db에 전송
							FilesDTO fdto1 = new FilesDTO(0, oriName, savedName,null, dto.getSeq(),0,0,0);
	
							int result = fservice.uploadFiles(dto.getSeq(),fdto1);
							System.out.println("파일 추가 결과? " +result );
							if (result > 0) {
								File targetLoc = new File(filesPath.getAbsolutePath() + "/" + savedName);
								FileCopyUtils.copy(mf.getBytes(), targetLoc);
							}
						}
					}
				}
				model.addAttribute("cpage", 1);
				model.addAttribute("mid_name",mid_name);
				model.addAttribute("type",type);
			}
			return "redirect:/noBoard/notificationBoardList.no?menu_seq="+dto.getMenu_seq()+"&type="+type;
	
		}
	//회사공지 게시글 삭제 (관리자 ONLY)
	@RequestMapping("notificationBoardDelete.no")
	public String notificationBoardDelete(int seq,int menu_seq,int cpage,Model model) {

		SidebarViewDTO sviewDTO  = sservice.selectInfor(menu_seq);
		String mid_name = sviewDTO.getMid_name();
		String type = sviewDTO.getType();
		//게시글 삭제
		int result = nservice.notificationBoardContentsDel(seq);
		
		//파일 삭제 - 파일의 seq로 삭제
		int fileDelResult = fservice.deleteNotificationBoardFiles(seq);
		
		model.addAttribute("cpage",cpage);
		model.addAttribute("seq",seq);
		model.addAttribute("menu_seq",menu_seq);
		return "redirect:/noBoard/notificationBoardList.no?menu_seq="+menu_seq+"&type="+type;
	}
	@ExceptionHandler
	public String exceptionHandler(Exception e) {
		e.printStackTrace();
		return "error";
	}
}
