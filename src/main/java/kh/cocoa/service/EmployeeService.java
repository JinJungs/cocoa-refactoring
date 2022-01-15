package kh.cocoa.service;

import kh.cocoa.dao.EmployeeDAO;
import kh.cocoa.dto.EmployeeDTO;
//import kh.cocoa.dto.NexacroSearchDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService implements EmployeeDAO {
	@Autowired
	private EmployeeDAO edao;
	@Autowired
	private BCryptPasswordEncoder pwEncoder;

	//----------------- 로그인 -----------------//
	@Override
	public String login(int code, String password) {

		//return edao.login(code, password);

		String result =  edao.login(code, password);
		System.out.println(result);
//		if(pwEncoder.matches(password, result)) {
//			return "T";
//		} else {
//			return "F";
//		}
		return "T";
	}

	@Override
	public EmployeeDTO loginInfo(int code) { return edao.loginInfo(code); }

	@Override
	public int myInfoModify(String password, String gender, String phone, String address, String office_phone, int code){
		if(password != null){
			pwEncoder = new BCryptPasswordEncoder();
			password = pwEncoder.encode(password);
		}
		return edao.myInfoModify(password, gender, phone, address, office_phone, code);
	}

	@Override
	public List<EmployeeDTO> findIdByEmail(String email) { return edao.findIdByEmail(email); }

	@Override
	public String findPwByEmail(String email, int code) { return edao.findPwByEmail(email, code); }

	@Override
	public int updateTempPw(String password, int code) {
		if(password != null){
			pwEncoder = new BCryptPasswordEncoder();
			password = pwEncoder.encode(password);
		}
		return edao.updateTempPw(password, code);
	}

	public static String getRandomStr(int size) {
		if(size > 0) {
			char[] temp = new char[size];
			for(int i = 0; i < temp.length; i++) {
				int div = (int)Math.floor(Math.random() * 2);

				if(div == 0) {	// 0일때 숫자
					temp[i] = (char)(Math.random() * 10 + '0');
				}else {	// 1일때 알파벳
					temp[i] = (char)(Math.random() * 26 + 'A');
				}
			}
			return new String(temp);
		}
		return new String("Error");
	}

	//전체 멤버 호출
	@Override
	public List<EmployeeDTO> getAllEmployee(){
		return edao.getAllEmployee();
	}
	//재직중인 전체 멤버 리스트 - 자신제외
	@Override
	public List<EmployeeDTO> getAllEmployeeExceptMe(int code){ return edao.getAllEmployeeExceptMe(code); }
	//사용자와 같은 부서멤버 호출
	@Override
	public List<EmployeeDTO> getDeptMember(int dept_code) {
		return edao.getDeptMember(dept_code);
	}
	//사용자와 같은 팀 멤버 호출
	@Override
	public List<EmployeeDTO> getTeamMember(int team_code) {
		return edao.getTeamMember(team_code);
	}

	//용국 메서드
	@Override
	public List<EmployeeDTO> getOrganChart() {
		return edao.getOrganChart();
	}

	//선택자 뽑아오는 서비스

	@Override
	public List<EmployeeDTO> getConfirmEmp(int code) {
		return edao.getConfirmEmp(code);
	}

	//팀코드로 직책꺼내오기
	@Override
	public List<EmployeeDTO> getEmpPos(int code) {return edao.getEmpPos(code); }

	@Override
	public EmployeeDTO getEmpInfo(int code) {return edao.getEmpInfo(code); }

	@Override
	public int getTeamCount(int team_code) {
		return edao.getTeamCount(team_code);
	}

	@Override
	public List<EmployeeDTO> getTeamEmpList(int team_code) {
		return edao.getTeamEmpList(team_code);
	}

	@Override
	public List<EmployeeDTO> getEmpNameSearchList(String name) {
		return edao.getEmpNameSearchList(name);
	}

	@Override
	public List<EmployeeDTO> getDeptNameSearchList(String name) {
		return edao.getDeptNameSearchList(name);
	}

	@Override
	public List<EmployeeDTO> getDeptEmpList(int dept_code) {
		return edao.getDeptEmpList(dept_code);
	}

	@Override
	public List<EmployeeDTO> getAllEmpListOrderByPos() {
		return edao.getAllEmpListOrderByPos();
	}

	@Override
	public int getAllEmpCount() {
		return edao.getAllEmpCount();
	}

	@Override
	public int getEmpCheckPw(int code, String password) {
		String result =  edao.login(code, password);
		if(pwEncoder.matches(password, result)) {
			return 1;
		} else {
			return 0;
		}
	}

	@Override
	public int modInfo(EmployeeDTO dto) {
		return edao.modInfo(dto);
	}

	@Override
	public int checkUserEmail(int code, String email) {
		return edao.checkUserEmail(code,email);
	}

	@Override
	public List<EmployeeDTO> getTeamEmp(int team_code) {
		return edao.getTeamEmp(team_code);
	}

	@Override
	public List<EmployeeDTO> getSearchEmpCode(String name) {
		return edao.getSearchEmpCode(name);
	}

	@Override
	public int changePw(int code,String password) {
		pwEncoder = new BCryptPasswordEncoder();
		password = pwEncoder.encode(password);
		return edao.changePw(code,password);
	}

	@Override
	public int isWithdraw(int code) {
		return edao.isWithdraw(code);
	}

	@Override
	public List<Integer> getAllEmpCode() {
		return edao.getAllEmpCode();
	}

	@Override
	public List<EmployeeDTO> getAllMWEmpCode() {
		return edao.getAllMWEmpCode();
	}

	//----------------- 채팅 -----------------//
	// 멤버이름으로 찾기
	@Override
	public List<EmployeeDTO> searchEmployeeByName(int code, String contents){
		return edao.searchEmployeeByName(code, contents);
	}
	// 부서이름으로 찾기
	@Override
	public List<EmployeeDTO> searchEmployeeByDeptname(int code, String contents){
		return edao.searchEmployeeByDeptname(code, contents);
	}
	//팀이름으로 찾기
	@Override
	public List<EmployeeDTO> searchEmployeeByTeamname(int code, String contents){
		return edao.searchEmployeeByTeamname(code, contents);
	}

	@Override
	public int isEmailExist(String email) {
		return edao.isEmailExist(email);
	}
	/*-------------지영------------*/
	//BugReport
	public EmployeeDTO getSenderEmail(int writer_code) {
		return edao.getSenderEmail(writer_code);
	}
	@Override
	public String getB_Email(String seq) {
		return edao.getB_Email(seq);
	}
	
	/*-------소형 관리자 사용자관리---------*/
	@Override
	public List<EmployeeDTO> getAllEmployeeOrderByCode() {
		return edao.getAllEmployeeOrderByCode();
	}
//	@Override
//	public List<EmployeeDTO> searchEmployee(NexacroSearchDTO dto){
//		return edao.searchEmployee(dto);
//	};
	@Override
	public int addEmployee(List<EmployeeDTO> list) {
		return edao.addEmployee(list);
	};
	@Override
	public int addOneEmployee(EmployeeDTO dto) {
		return edao.addOneEmployee(dto);
	};
	@Override
	public int updateEmployee(List<EmployeeDTO> list) {
		return edao.updateEmployee(list);
	};
	@Override
	public int updateWithdraw(List<EmployeeDTO> dto) {
		return edao.updateWithdraw(dto);
	}
	/*-------소형 끝 관리자 사용자관리*/
	
	@Override
	public String getEmpNameByCode(int code) {
		return edao.getEmpNameByCode(code);
	}
	
	@Override
	public List<EmployeeDTO> getEmpleLTU() {
		return edao.getEmpleLTU();
	}
	@Override
	public List<EmployeeDTO> getListWithdrawN() {
		return edao.getListWithdrawN();
	}

}

