//package kh.cocoa.controller;
//
//import kh.cocoa.dto.EmployeeDTO;
//import kh.cocoa.dto.SidebarViewDTO;
//import kh.cocoa.service.FilesService;
//import kh.cocoa.service.SidebarService;
//import kh.cocoa.statics.Configurator;
//import lombok.extern.slf4j.Slf4j;
//import org.json.JSONArray;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Controller;
//import org.springframework.web.bind.annotation.RequestBody;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.ResponseBody;
//
//import javax.servlet.http.HttpSession;
//import java.util.ArrayList;
//import java.util.HashMap;
//import java.util.List;
//
//@Controller
//@RequestMapping("/sidebar")
//@Slf4j
//public class DelSidebarController {
//
//    @Autowired
//    private SidebarService sService;
//
//    @Autowired
//    private HttpSession session;
//
//    @Autowired
//    private FilesService filesService;
//
//    // ajax로 사이드바에 값을 보내준다.
//    // 사용자 정보도 같이 보내줘야한다.
//    @RequestMapping("getSidebarList")
//    @ResponseBody
//    public String getSidebarList(String test){
//        JSONArray jArrayAll = new JSONArray(); //전체 리스트를 담을 jsonarray
//        HashMap<String,Object> param = null;
//        EmployeeDTO loginDTO = (EmployeeDTO)session.getAttribute("loginDTO");
//        // 사이드바 메뉴의 개수
//        int menuCount = sService.sidebarMenuCount();
//
//        // 사이드바 메뉴의 개수만큼 for문을 돌린다. 이때, k = menu_seq 이다.
//        for (int k=1; k<menuCount+1; k++){
//            // 1. 메뉴 개수만큼 jsonArray 생성 - 하위목록이 없어도 만든다.
//            JSONArray jArray = new JSONArray();
//            // 2. 하위목록의 개수를 센다
//            int subCount = sService.sidebarCountByMenuSeq(k);
//            // System.out.println("subCount: " + subCount);
//            if(subCount !=0) {
//                // 3. 하위 메뉴의 개수가 0개가 아닐 때, 해당메뉴의 리스트를 불러온다.
//                List<SidebarViewDTO> list = sService.sidebarListByMenuSeq(k);
//                //  System.out.println("list 사이즈 ? 여기서 null인가? "  +list.size());
//                // 4. jArray에 리스트를 담는다.
//                for(int i=0; i<list.size(); i++){
//                    param = new HashMap<>();
//                    param.put("code", list.get(i).getCode());
//                    param.put("mid_code", list.get(i).getMid_code());
//                    param.put("mid_name", list.get(i).getMid_name());
//                    param.put("sub_name", list.get(i).getSub_name());
//                    param.put("menu_seq", list.get(i).getMenu_seq());
//                    param.put("status", list.get(i).getStatus());
//                    param.put("board_menu_seq", list.get(i).getBoard_menu_seq());
//                    param.put("menu_name", list.get(i).getMenu_name());
//                    param.put("type", list.get(i).getType());
//                    param.put("contents", list.get(i).getContents());
//                    jArray.put(param);
//                }
//                // 하위 메뉴의 개수만큼 for문
//                for (int j=0; j<subCount; j++){
//                    //  System.out.println("menu_seq가 "+k+"일 때 : " +list.get(j).getMid_name());
//                }
//            }else{
//                //   System.out.println("리스트 없음!");
//            }
//            jArrayAll.put(jArray);
//        }
//        // 로그인 한 사용자 정보도 같이 담아서 보내준다.
//        param = new HashMap<>();
//        param.put("code",loginDTO.getCode());
//        param.put("name", loginDTO.getName());
//        param.put("deptname",loginDTO.getDeptname());
//        param.put("teamname",loginDTO.getTeamname());
//        param.put("posname",loginDTO.getPosname());
//        // 사용자 프로필 정보는 수정 후 바로 반영하기 위해서 매번 새로 가져온다.
//        String myProfileLoc = filesService.getProfile(loginDTO.getCode());
//        loginDTO.setProfile(myProfileLoc);
//        param.put("profile",loginDTO.getProfile());
//
//        jArrayAll.put(param);
//        return jArrayAll.toString();
//    }
//
////    @RequestMapping("getSidebarList.nex")
////    public NexacroResult getSidbarList(){
////        NexacroResult nr = new NexacroResult();
////        List<SidebarViewDTO> list = sService.getSidebarList();
////        // chk에 모두 0값을 넣어서 보낸다.
////        for(int i=0; i<list.size(); i++){
////            list.get(i).setChk("0");
////        }
////        nr.addDataSet("out_ds",list);
////        return nr;
////    }
////
////    @RequestMapping("updateSidebar.nex")
////    public NexacroResult updateSidebar(@ParamDataSet(name="in_ds")List<SidebarViewDTO> list){
////        NexacroResult nr = new NexacroResult();
////        System.out.println("상태 : " + list.get(0).getStatus());
////        System.out.println("내용 : " + list.get(0).getContents());
////        //int result = sService.updateSidebar(sdto);
////        int result = sService.updateSidebarAll(list);
////        return nr;
////    }
//
//    @RequestMapping("/addSideBarStatus")
//    @ResponseBody
//    public void addSideBarStatus(@RequestBody List<String> map){
//        if(map.size()==0){
//            session.removeAttribute("status");
//        }else{
//            session.setAttribute("status",map);
//        }
//
//    }
//
//    @RequestMapping("/getSidebarStatus")
//    @ResponseBody
//    public String getSidebarStatus(){
//        ArrayList<String> status= new ArrayList<>();
//        if(Configurator.restart==0){
//            session.removeAttribute("status");
//            Configurator.restart++;
//            return "";
//        }
//        status = (ArrayList) session.getAttribute("status");
//        JSONArray json = new JSONArray(status);
//        return json.toString();
//
//    }
//
//}
