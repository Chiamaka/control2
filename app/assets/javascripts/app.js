
/*
File contains common functions used by most pages in the application 


*/
$(document).ready(function () {

	(function ($) {

		$('#filter').keyup(function () {

			var rex = new RegExp($(this).val(), 'i');
			$('.searchable tr').hide();
			$('.searchable tr').filter(function () {
				return rex.test($(this).text());
			}).show();

		})

	}(jQuery));

});

//bank fade effect

function bankPage(option){
	if(option === "dashboard"){
		$("#dashboard").show();
		$("#accounts").hide();
		$("#profile").hide();
		$("#transactions").hide();
		}
	else if (option === "accounts"){
		$("#accounts").show();
		$("#dashboard").hide();
		$("#profile").hide();
		$("#transactions").hide();
	}
	else if (option === "transactions"){
		$("#transactions").show();
		$("#accounts").hide();
		$("#dashboard").hide();
		$("#profile").hide();
	}
	else{
		$("#profile").show();
		$("#dashboard").hide();
		$("#accounts").hide();
		$("#transactions").hide();

	}
}
window.baseUrl="http://localhost:3000";
function init(){
	$("#accounts").hide();
	$("#profile").hide();
	$("#transactions").hide();

}init();

//request function for making ajax call
function request(callback,method,url){
	var xhr = new XMLHttpRequest();
	xhr.withCredentials = true;

	xhr.addEventListener("readystatechange", function() {
		if (this.readyState === this.DONE) {

			callback( this.responseText);
			console.log(this.responseText);

		}


	});

	xhr.open(method, window.baseUrl+url);
//xhr.setRequestHeader("content-type", "application/json");

xhr.send("");
}

//function for getting transactions of citizens
function transaction(id,token) {
	request(function (jsondata) {
		object = JSON.parse(jsondata);
		var data = object.table.transactions;
		for(i = 0 ; data.length > i ;i++){
			imediateData=data[i];
			if(imediateData.citizen_id === id ){

				$("#mod-data").html("<tr><td>"+imediateData.transaction_name+"</td><td >"+imediateData.transaction_amount+"</td> <td>"
					+imediateData.account_balance+"</td> <td>"+imediateData.updated_at+"</td></tr>");	
				$('#tran').addClass('show');
			}
		}

	},"GET","/transaction/get.json?token="+token);

}

//change token of banks
function changeToken(oldToken) {
	if (confirm('Are you sure you want to change your current token?')) {
		request(function (jsondata) {
			object=JSON.parse(jsondata);
			console.log("changeToken function called,Results:"+object.table.newToken);
			$(".ctoken").html(object.table.newToken);
		},"GET","/tokengen.json?token="+oldToken);
		 
	} else {
		console.log("token change ignored");
	}
};



function miniDocs(){
	console.log("calling Docs")
	$('#docs').addClass('show');
};
	