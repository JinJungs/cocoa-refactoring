package kh.cocoa.controller;

import java.io.File;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import kh.cocoa.dto.BoardDTO;
import kh.cocoa.dto.DocumentDTO;
import kh.cocoa.dto.EmployeeDTO;
import kh.cocoa.dto.FilesDTO;
import kh.cocoa.service.BusinessLogService;
import kh.cocoa.service.ConfirmService;
import kh.cocoa.service.FilesService;
import kh.cocoa.statics.Configurator;

@Controller
@RequestMapping("/log")
public class BusinessLogController {

	@Autowired
	private BusinessLogService bservice;

	@Autowired
	private FilesService fservice;

	@Autowired
	private ConfirmService cservice;

	@Autowired
	private HttpSession session;

	//업무일지 작성 페이지로 이동
	@RequestMapping("logCreate.log")
	public String logCreate() {
		EmployeeDTO loginDTO = (EmployeeDTO)session.getAttribute("loginDTO");

		int writer_code = (Integer)loginDTO.getCode();
		int dept_code = (Integer)loginDTO.getDept_code();
		if(dept_code==0) {
			return "businessLog/Alert";
		}

		return "businessLog/logCreate";
	}
	//업무일지 임시보관 작성 완료
	@RequestMapping("logTempSave.log")
	public String logTempSave(DocumentDTO ddto,String selectBy,List<MultipartFile> file) throws Exception {
		EmployeeDTO loginDTO = (EmployeeDTO)session.getAttribute("loginDTO");
		int writer_code = (Integer)loginDTO.getCode();
		ddto.setWriter_code(writer_code);
		ddto.setContents(Configurator.XssReplace(ddto.getContents()));
		ddto.setTitle(Configurator.XssReplace(ddto.getTitle()));
		//문서저장에 필요한 dept_code
		int dept_code = (Integer)loginDTO.getDept_code();
		
		//업무일지 seq & files doc_seq 맞추기
		int logDoc_seq= bservice.logDocSelectSeq();

		//임시 문서 저장
		int tempSavedLog = bservice.tempSavedLog(logDoc_seq,ddto,selectBy,dept_code);

		//파일 업로드
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
						FilesDTO fdto = new FilesDTO(0, oriName, savedName,null,0,logDoc_seq,0,0);

						int result = fservice.uploadFilesBusinessLog(logDoc_seq,fdto);
						if (result > 0) {
							File targetLoc = new File(filesPath.getAbsolutePath() + "/" + savedName);
							FileCopyUtils.copy(mf.getBytes(), targetLoc);
						}
					}
				}
			}
		}
		return "redirect:/log/logBoard.log?status=TEMP"; //경로 바꿔줘야함
	}
	//업무일지 작성 완료
	@RequestMapping("logCreateDone.log")
	public String logCreateDone(DocumentDTO ddto,String selectBy,List<MultipartFile> file) throws Exception {
		EmployeeDTO loginDTO = (EmployeeDTO)session.getAttribute("loginDTO");
		ddto.setContents(Configurator.XssReplace(ddto.getContents()));
		ddto.setTitle(Configurator.XssReplace(ddto.getTitle()));
		int writer_code = (Integer)loginDTO.getCode();
		ddto.setWriter_code(writer_code);
		//문서저장에 필요한 dept_code
		int dept_code = (Integer)loginDTO.getDept_code();
		ddto.setDept_code(dept_code);
		
		int pos_code = (Integer)loginDTO.getPos_code();
		ddto.setDept_code(pos_code);

		//업무일지 seq & files doc_seq 맞추기
		int logDoc_seq= bservice.logDocSelectSeq();

		//업무일지 종류에 따라 문서 저장
		int createLog = bservice.createLog(logDoc_seq,ddto,selectBy,dept_code);
		
		//파일 업로드
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
						FilesDTO fdto = new FilesDTO(0, oriName, savedName,null,0,logDoc_seq,0,0);

						int result = fservice.uploadFilesBusinessLog(logDoc_seq,fdto);
						if (result > 0) {
							File targetLoc = new File(filesPath.getAbsolutePath() + "/" + savedName);
							FileCopyUtils.copy(mf.getBytes(), targetLoc);
						}
					}
				}
			}
		}
		return "redirect:/log/logSentBoard.log";
	}
	//업무일지 읽기
	@RequestMapping("logRead.log")
	public String logRead(int seq,Model model, String status, DocumentDTO ddto, FilesDTO fdto) {

		EmployeeDTO loginDTO = (EmployeeDTO)session.getAttribute("loginDTO");
		int writer_code = (Integer)loginDTO.getCode();
		//로그인한 정보의 code를 DocumentDTO writer_code에 넣어주기
		ddto.setWriter_code(writer_code);

		//업무일지 자료 가져오기
		DocumentDTO logRead = bservice.getLogBySeq(seq);

		//게시글에 업로드된 파일 갯수 확인
		int getLogUploadFileCount = fservice.getLogUploadFileCount(fdto);

		//업로드된 파일 가져오기
		List<FilesDTO> fileList = fservice.getLogFilesBySeq(seq,fdto);
		
		//승인한 사람 이름 불러오기
		List<EmployeeDTO> confirmBy = cservice.confirmBy(seq);

		//거절한 사람 이름 불러오기
		List<EmployeeDTO> rejectBy = cservice.confirmBy(seq);
		
		model.addAttribute("status",status);
		model.addAttribute("lr",logRead);
		model.addAttribute("fileList",fileList);
		model.addAttribute("confirmBy",confirmBy);
		model.addAttribute("fileCount",getLogUploadFileCount);
		return "businessLog/logRead";
	}
	//확인요청 업무일지 - 거절
	@RequestMapping("logReqCheck.log")
	public String logReqCheck(String status,int seq,Model model,DocumentDTO ddto) {
		EmployeeDTO loginDTO = (EmployeeDTO)session.getAttribute("loginDTO");
		int writer_code = (Integer)loginDTO.getCode();
		//로그인한 정보의 code를 DocumentDTO writer_code에 넣어주기
		ddto.setWriter_code(writer_code);
		//거절의 경우 - DOCUMENT에 넣어주기
		int updateStatusReject = bservice.updateStatusReject(seq,status);

		//거절의 경우 - doc_confirm에도 넣어주기
		int rejectDoc = cservice.rejectDoc(seq,ddto);	
		return "redirect:/log/logBoard.log?status="+status;
	}	
	//확인요청 업무일지 - 승인
	@RequestMapping("logReqCheck2.log")
	public String logReqCheck2(String status,DocumentDTO ddto,int seq,String report_contents) {
		EmployeeDTO loginDTO = (EmployeeDTO)session.getAttribute("loginDTO");
		int writer_code = (Integer)loginDTO.getCode();
		//로그인한 정보의 code를 DocumentDTO writer_code에 넣어주기
		ddto.setWriter_code(writer_code);
		//승인의 경우 - doc테이블에 내용업뎃
		int updateStatusConfirm = bservice.updateStatusConfirm(seq,report_contents);
		
		//승인의 경우 doc_confirm 테이블에 업뎃
		int docConf = cservice.docConf(seq,ddto);
			
		return "redirect:/log/logBoard.log?status="+status;
	}	
	//업무일지 삭제 (임시보관 ONELY)
	@RequestMapping("logDel.log")
	public String logDel(int seq,String status) {
		//임시보관 문서 삭제
		int result = bservice.logDel(seq);

		//임시보관 된 문서 지우기
		int logFileDel = fservice.logFileDel(seq);
		
		if(status.contentEquals("RAISE")) {
			return "redirect:/log/logSentBoard.log";
		}
		return "redirect:/log/logBoard.log?status="+status;
	}
	//요청 받은 업무일지 읽기
	@RequestMapping("logReqRead.log")
	public String logReqRead(int seq,String status,DocumentDTO ddto,FilesDTO fdto,Model model) {
		EmployeeDTO loginDTO = (EmployeeDTO)session.getAttribute("loginDTO");
		int writer_code = (Integer)loginDTO.getCode();
		System.out.println(writer_code);
		//로그인한 정보의 code를 DocumentDTO writer_code에 넣어주기
		ddto.setWriter_code(writer_code);
		
		//작성자 이름가져오기 
		String writer_name = (String)loginDTO.getName();
		//업무일지 자료 가져오기
		DocumentDTO logRead = bservice.getLogBySeq(seq);
		
		//게시글에 업로드된 파일 갯수 확인
		int getLogUploadFileCount = fservice.getLogUploadFileCount(fdto);

		//업로드된 파일 가져오기
		List<FilesDTO> fileList = fservice.getLogFilesBySeq(seq,fdto);

		model.addAttribute("fileList",fileList);
		model.addAttribute("fileCount",getLogUploadFileCount);

		model.addAttribute("lr",logRead);
		model.addAttribute("status",status);
		model.addAttribute("seq",seq);
		model.addAttribute("writer_name",writer_name);
		
		return "businessLog/logReqRead";
	}
	//업무일지 수정 & 임시저장된 문서 수정 페이지로 이동
	@RequestMapping("logModify.log")
	public String logModify(int seq,String status,DocumentDTO dto,FilesDTO fdto, Model model) {
		
		DocumentDTO logRead = bservice.getLogBySeqMod(seq,dto,status);
		
		//업로드된 파일 가져오기
		List<FilesDTO> fileList = fservice.getLogFilesBySeq(seq,fdto);

		//승인한 사람 이름 불러오기
		List<EmployeeDTO> confirmBy = cservice.confirmBy(seq);
		
		model.addAttribute("lr",logRead);
		model.addAttribute("status",status);
		model.addAttribute("fileList",fileList);
		model.addAttribute("confirmBy",confirmBy);


		return "businessLog/logModify";
	}
	//수정 완료
	@RequestMapping("logModifyDone.log")
	public String logModifyDone(int temp_code, int[] delArr,int seq,DocumentDTO ddto,FilesDTO fdto, String status,
			List<MultipartFile> file) throws Exception {
		if(temp_code==1) {
			//수정 후 상신 (일일)
			int logModifyDaily = bservice.logModifyDaily(ddto);

		}else if (temp_code==2) {
			//수정 후 상신 (주간/월별)
			int logModify = bservice.logModify(ddto);
		}else if (temp_code==3) {
			//수정 후 상신 (주간/월별)
			int logModifyMonth = bservice.logModifyMonth(ddto);
		}
		/*------------------파일 수정--------------*/
		//파일 삭제 - 파일의 seq로 삭제
		if (delArr != null) {
			int fileDelResult = 0;
			for (int i = 0; i < delArr.length; i++) {
				fileDelResult += fservice.deleteNotificationBoardFiles(delArr[i]);
			}
		}
		//파일 추가
		if(file!=null) { if (!file.get(0).isEmpty()) { //파일추가 없이 글쓰기 
			String fileRoot = Configurator.boardFileRootC; //파일 저장할 경로
			File filesPath = new File(fileRoot);
			//폴더 없으면 만들기
			if(!filesPath.exists()) {filesPath.mkdir();}
			for (MultipartFile mf : file) {
				String oriName = mf.getOriginalFilename();
				String uid = UUID.randomUUID().toString().replaceAll("-", "");
				String savedName = uid + "-" + oriName;
				// dto에 값을 담아서 db에 전송
				FilesDTO fdto1 = new FilesDTO(0, oriName, savedName,null,0, seq,0,0);

				int result = fservice.uploadFilesTempSave(seq,fdto1);
				if (result > 0) {
					File targetLoc = new File(filesPath.getAbsolutePath() + "/" + savedName);
					FileCopyUtils.copy(mf.getBytes(), targetLoc);
				}
			}
		}
		}
		return "redirect:/log/logSentBoard.log";
	}
	//수정 페이지 - 임시저장 완료
	@RequestMapping("logModifyTempSave.log")
	public String logModifyTempSave(int temp_code, int[] delArr,int seq,DocumentDTO ddto,FilesDTO fdto, String status,
			List<MultipartFile> file) throws Exception{
		if(temp_code==1) {
			//ddto.setReport_end(null);
			//임시저장될 문서
			int logModifyTempUpdateDaily = bservice.logModifyTempUpdateDaily(ddto);

		}else if (temp_code==2) {
			//임시저장될 문서
			int logModifyTempUpdate = bservice.logModifyTempUpdate(ddto);
		}else if (temp_code==3) {
			//임시저장될 문서
			int logModifyTempUpdateMonth = bservice.logModifyTempUpdateMonth(ddto);
		}
		/*------------------파일 수정--------------*/
		//파일 삭제 - 파일의 seq로 삭제
		if (delArr != null) {
			int fileDelResult = 0;
			for (int i = 0; i < delArr.length; i++) {
				fileDelResult += fservice.deleteNotificationBoardFiles(delArr[i]);
			}
		}
		//파일 추가
		if(file!=null) { if (!file.get(0).isEmpty()) { //파일추가 없이 글쓰기 
			String fileRoot = Configurator.boardFileRootC; //파일 저장할 경로
			File filesPath = new File(fileRoot);
			//폴더 없으면 만들기
			if(!filesPath.exists()) {filesPath.mkdir();}
			for (MultipartFile mf : file) {
				String oriName = mf.getOriginalFilename();
				String uid = UUID.randomUUID().toString().replaceAll("-", "");
				String savedName = uid + "-" + oriName;
				// dto에 값을 담아서 db에 전송
				FilesDTO fdto1 = new FilesDTO(0, oriName, savedName,null,0, seq,0,0);

				int result = fservice.uploadFilesTempSave(seq,fdto1);
				if (result > 0) {
					File targetLoc = new File(filesPath.getAbsolutePath() + "/" + savedName);
					FileCopyUtils.copy(mf.getBytes(), targetLoc);
				}
			}
		}
		}
		return "redirect:/log/logBoard.log?status=TEMP";
	}
	//보관함 (임시저장 / 업무일지 / 확인요청)
	@RequestMapping("logBoard.log")
	public String logTempBoard(String status,Model model) {
		EmployeeDTO loginDTO = (EmployeeDTO)session.getAttribute("loginDTO");
		int writer_code = (Integer)loginDTO.getCode();
		int dept_code = (Integer)loginDTO.getDept_code();
		int pos_code = (Integer)loginDTO.getPos_code();

		//임시저장 보관함인 경우 접속한 ID와 작성자가 동일한 문서만 불러오기
		if(status.contentEquals("TEMP")) {
			if(dept_code==0) {
				return "businessLog/Alert";
			}
			//글 전체 리스트
			List<BoardDTO> logAllList = bservice.getLogAllList(status,writer_code);
			//일일 리스트 불러오기 
			List<BoardDTO> dailyList = bservice.dailyList(status,writer_code);
			//주간 리스트 불러오기
			List<BoardDTO> weeklyList = bservice.weeklyList(status,writer_code);
			//월별 리스트 불러오기
			List<BoardDTO> monthlyList = bservice.monthlyList(status,writer_code);

			model.addAttribute("logAllList",logAllList);
			model.addAttribute("dailyList",dailyList);
			model.addAttribute("weeklyList",weeklyList);
			model.addAttribute("monthlyList",monthlyList);

		//확인요청 보관함인 경우 접속한 ID와 작성자가 동일한 문서 & 본인과 같은 부서의 직급이 낮은 직원의 글 불러오기
		}else if (status.contentEquals("RAISE")){
			//팀원인 경우 로그인 화면으로 돌아감
			if(pos_code==4 || dept_code==0) {
				return "businessLog/Alert";
			}
			//글 전체 리스트
			List<BoardDTO> logAllListR = bservice.logAllListR(status,pos_code,dept_code);
			//일일 리스트 불러오기 
			List<BoardDTO> dailyListR = bservice.dailyListR(status,pos_code,dept_code);
			//주간 리스트 불러오기
			List<BoardDTO> weeklyListR = bservice.weeklyListR(status,pos_code,dept_code);
			//월별 리스트 불러오기
			List<BoardDTO> monthlyListR = bservice.monthlyListR(status,pos_code,dept_code);

			model.addAttribute("logAllList",logAllListR);
			model.addAttribute("dailyList",dailyListR);
			model.addAttribute("weeklyList",weeklyListR);
			model.addAttribute("monthlyList",monthlyListR);

			//업무일지 보관함인 경우 같은 부서사람의 문서이자 승인 받은 문서만 보여주기
		}else if(status.contentEquals("CONFIRM")) {
			if(dept_code==0) {
				return "businessLog/Alert";
			}
			//글 전체 리스트
			List<BoardDTO> logAllListC = bservice.logAllListC(status,dept_code);
			System.out.println(logAllListC.size());
			//일일 리스트 불러오기 
			List<BoardDTO> dailyListC = bservice.dailyListC(status,dept_code);
			//주간 리스트 불러오기
			List<BoardDTO> weeklyListC = bservice.weeklyListC(status,dept_code);
			//월별 리스트 불러오기
			List<BoardDTO> monthlyListC = bservice.monthlyListC(status,dept_code);

			model.addAttribute("logAllList",logAllListC);
			model.addAttribute("dailyList",dailyListC);
			model.addAttribute("weeklyList",weeklyListC);
			model.addAttribute("monthlyList",monthlyListC);
		}
		model.addAttribute("status",status);
		return "businessLog/logBoard";
	}

	//보낸 업무일지 보관함 	
	@RequestMapping("logSentBoard.log")
	public String logSentBoard(Model model) {
		EmployeeDTO loginDTO = (EmployeeDTO)session.getAttribute("loginDTO");
		int writer_code = (Integer)loginDTO.getCode();
		int dept_code = (Integer)loginDTO.getDept_code();
		if(dept_code==0) {
			return "businessLog/Alert";
		}
		//전체
		List<BoardDTO> sentLogAllList = bservice.sentLogAllList(writer_code);
		//일일
		List<BoardDTO> sentLogDailyList = bservice.sentLogDailyList(writer_code);
		//주간
		List<BoardDTO> sentLogWeeklyList = bservice.sentLogWeeklyList(writer_code);
		//월별
		List<BoardDTO> sentLogMonthlyList = bservice.sentLogMonthlyList(writer_code);

		model.addAttribute("logAllList",sentLogAllList);
		model.addAttribute("dailyList",sentLogDailyList);
		model.addAttribute("weeklyList",sentLogWeeklyList);
		model.addAttribute("monthlyList",sentLogMonthlyList);
		return "businessLog/logSentBoard";
	}
}