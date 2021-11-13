package kh.cocoa.service;

import kh.cocoa.dao.SidebarDAO;
import kh.cocoa.dto.SidebarViewDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SidebarService implements SidebarDAO{

    @Autowired
    private SidebarDAO sdao;

    @Override
    public int sidebarMenuCount() {
        return sdao.sidebarMenuCount();
    }

    // menu_seq에 따른 리스트의 개수
    @Override
    public int sidebarCountByMenuSeq(int menu_seq) {
        return sdao.sidebarCountByMenuSeq(menu_seq);
    }

    // menu_seq에 따른 리스트
    @Override
    public List<SidebarViewDTO> sidebarListByMenuSeq(int menu_seq) {
        return sdao.sidebarListByMenuSeq(menu_seq);
    }
    
    // ---- 넥사크로 ----
    // 사이드바 전체리스트 가져오기
    @Override
    public List<SidebarViewDTO> getSidebarList() {
        return sdao.getSidebarList();
    }
    // 사이드바 update - dto 한개만
    @Override
    public int updateSidebar(SidebarViewDTO sdto){ return sdao.updateSidebar(sdto);}
    // 사이드바 update - list로
    @Override
    public int updateSidebarAll(List<SidebarViewDTO> list){ return sdao.updateSidebarAll(list);}


	//넥사크로 사이드바에 게시판 추가
	public int addSideBar(String name,int board_menu_seq) {
		return sdao.addSideBar(name,board_menu_seq);
	}
	//게시글 이름& 타입 가져오기
	public SidebarViewDTO selectInfor(int menu_seq) {
		return sdao.selectInfor(menu_seq);
	}
	public int uptSideBar(String name, int seq) {
		return sdao.uptSideBar(name,seq);
	}
	public int delBoard(int seq) {
		return sdao.delBoard(seq);
	}

}
