package kh.cocoa.controller;


import kh.cocoa.dao.DepartmentsDAO;
import kh.cocoa.dto.DepartmentsDTO;
import kh.cocoa.dto.EmployeeDTO;
import kh.cocoa.service.DepartmentsService;
import kh.cocoa.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/organ")
public class OranChartController {

    @Autowired
    private DepartmentsService deptservice;
    @Autowired
    private EmployeeService employeeService;
    @Autowired
    private HttpSession session;

    @RequestMapping("toOrganChart.organ")
    public String toOrganChart(Model model){
        EmployeeDTO loginDTO = (EmployeeDTO)session.getAttribute("loginDTO");
        int empCode = (Integer)loginDTO.getCode();
        List<DepartmentsDTO> dlist =deptservice.getDeptList();
        EmployeeDTO userInfo=employeeService.loginInfo(empCode);
        DepartmentsDTO getDept=deptservice.getDept();
        model.addAttribute("top",getDept);
        model.addAttribute("user",userInfo);
        model.addAttribute("dlist",dlist);
        return "/organChart/organChart";

    }

}
