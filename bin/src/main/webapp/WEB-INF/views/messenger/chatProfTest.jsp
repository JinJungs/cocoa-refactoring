<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chatting</title>
    <script src="https://code.jquery.com/jquery-3.5.1.js"></script>
    <style>
        * {
            box-sizing: border-box;
        }

        div {
            border: 1px solid black;
        }

        .container {
            margin: auto;
            width: 300px;
            height: 400px;
        }

        .contents {
            height: 80%;
            overflow-y: auto;
            word-wrap: break-word;
            background-color: #B2C7D9;
        }

        .input {
            height: 20%;
        }

        .input > div {
            float: left;
        }

        .message {
            width: 80%;
            height: 100%;
            overflow-y: auto;
        }

        .contents .my {
            background-color: #FFEB33;
            float: right;
            max-width: 140px;
            border-radius: 3px;
            display: inline-block;
            margin-top: 3px;
            margin-bottom: 3px;
            margin-right: 3px;
            padding: 2px;
            clear: both;
        }

        .contents .nmy {
            background-color: white;
            float: left;
            max-width: 140px;
            border-radius: 3px;
            display: inline-block;
            margin-top: 3px;
            margin-bottom: 3px;
            margin-left: 3px;
            padding: 2px;
            clear: both;
        }

        .controls {
            width: 20%;
            height: 100%;
            text-align: center;

        }
    </style>
</head>
<body>
<div class="container">
    <div class="contents" id="contents">
    </div>
    <div class="input">
        <!-- div속성에 contenteditable 을 주면 텍스트를 입력할 수 있고 -->
        <div class="message" contenteditable="true">
        </div>
        <div class="controls">
            <button id="send">전송</button>
        </div>
    </div>
    <input type="file" id="file">
    <button type="button" id="fileBtn" onclick="sendFile()">파일전송</button>
</div>

<script>

	$(document).ready(  function() {
		connectStomp();
		/* 텍스트 전송 */
		$('#sendBtn').on('click', function(evt) {
	        evt.preventDefault();
	        if (!isStomp && socket.readyState !== 1) return;
	        
	        let msg = $("#yourMsg").val();
	        console.log("mmmmmmmmmmmm>>", msg)
	        if (isStomp)
	        	socket.send('/getChat/text/'+${seq}, {}, JSON.stringify({
	        		type: 'message'
	        		, seq: ''
	        		, contents: msg
	        		, write_date: new Date()
	        		, emp_code: 1000
	        		, msg_seq: ${seq}}));
	        else
	            socket.send(msg);
	    });
		
		/* 파일 전송 sendFileBtn*/
		//파일 전송===================== ArrayBuffer로 변형 후 전송?
	 	$('#sendFileBtn').on('click', function(evt) {
	        evt.preventDefault();
	        if (!isStomp && socket.readyState !== 1) return;
	        
	        console.log("ffffffffffff>>", file)
	        
	        if (isStomp){
	        	var file = document.querySelector("#fileUpload").files[0];
	        	console.log(file);
	            var fileReader = new FileReader();
	            fileReader.onload = function() {
	                arrayBuffer = this.result;
	                console.log("Array contains", arrayBuffer.byteLength, "bytes.");
	                socket.send('/getChat/file', {}, arrayBuffer);
	            };
	            fileReader.readAsArrayBuffer(file);
	        }
	        	
	        else
	            socket.send(file);
	    }); 
	});
	
	var socket = null;
	var isStomp = false;
	
	function connectStomp() {
		var sock = new SockJS("/stompTest"); // endpoint
	    var client = Stomp.over(sock); //소크로 파이프 연결한 스톰프
		isStomp = true;
		socket = client;
	    
	    client.connect({}, function () {
	        console.log("Connected stompTest!");
	        // Controller's MessageMapping, header, message(자유형식)
	/*         let msg = {
	        			type: 'message'
	            		, seq: ''
	            		, contents: msg
	            		, write_date: new Date()
	            		, emp_code: 1000
	            		, msg_seq: 1};
	        client.send('/TTT', {}, JSON.stringify(msg)); */
	
	        // 해당 토픽을 구독한다!
	        client.subscribe('/topic/'+${seq}, function (event) {
	            console.log("!!!!!!!!!!!!event>>", event)
	        });
	    });
	
	}
//================================================================================
    let ws = new WebSocket("ws://localhost/websocket");

    // 메세지를 받는  것을 콜백함수로 만들어준다.
    ws.onmessage = function (e) {
        let message = e.data;
        let line = $("<div>");
        line.append(message);
        line.addClass("nmy");
        let br = $("<br>");
        $(".contents").append(line);
        $(".contents").append(br);
        scrollBottom();
    }

    function scrollBottom() {
        var contents = document.getElementById("contents");
        contents.scrollTop = contents.scrollHeight;
    }


    $(".message").on("keydown", function (e) {
        if (e.keyCode == 13) {
            let message = $(".message").html();
            $('.message').html("");

            let line = $("<div>");
            line.append(message);
            line.addClass("my");
            let br = $("<br>");

            $(".contents").append(line);
            $(".contents").append(br);
            scrollBottom();

            // message에 있는 내용을 line이라는 div에 담아서 contents div에 append

            // ---------------------------------------------
            ws.send(message); // 서버에게 메세지를 전송하는 코드
            return false;

            // 기본동작을 차단하는 것
            // -> enter를 쳤을 때 divd의 contenteditable이 div를 만드는 것을 차단
        }

    })

    function sendFile(){
        var file = document.getElementById('file').files[0];
        ws.send('filename:'+file.name);
        alert('test');

        var reader = new FileReader();
        var rawData = new ArrayBuffer();

        reader.loadend = function() {

        }

        reader.onload = function(e) {
            rawData = e.target.result;
            ws.send(rawData);
            alert("파일 전송이 완료 되었습니다.")
            ws.send('end');
        }

        reader.readAsArrayBuffer(file);
    }
</script>
</body>
</html>