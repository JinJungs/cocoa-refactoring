package kh.cocoa.dto;


import java.util.Date;


import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data //lombok을 사용하기 때문에 getter/setter를 포함된것 
@NoArgsConstructor // 기본 생성자 역활 - DTO에 없는 경우
public class FilesDTO {
	private int seq;
	private String oriname;
	private String savedname;
	private Date uploadeddate;
	private int board_seq;
	private int document_seq;
	private int msg_seq;
	private int email_seq;
	
   @Builder // 생성자가 id,nmae등 부분적으로 필요한것도 알아서 생성. 단, controller에서 해주어야할께 있음
   public FilesDTO(int seq, String oriname, String savedname, Date uploadeddate, int board_seq, int document_seq, int msg_seq, int email_seq) {
      this.seq = seq;
      this.oriname = oriname;
      this.savedname = savedname;
      this.uploadeddate = uploadeddate;
      this.board_seq = board_seq;
      this.document_seq = document_seq;
      this.msg_seq = msg_seq;
      this.email_seq = email_seq;
   }
   
   public FilesDTO(String oriname, String savedname,int email_seq) {
	  this.oriname = oriname;
      this.savedname = savedname;
      this.email_seq = email_seq;
   }
}
