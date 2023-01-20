({
	validate : function(component, event, helper) {
		var emailField = component.find("txtEmail");
        var emailFieldValue = emailField.get("v.value");
        // Store Regular Expression
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
        // check if Email field in not blank,
        // and if Email field value is valid then set error message to null, and remove error CSS class.
        // ELSE if Email field value is invalid then add Error Style Css Class, and set the error Message.          
        if(!$A.util.isEmpty(emailFieldValue)){   
            if(emailFieldValue.match(regExpEmailformat)){
                                
            }else{
                alert("Please Enter a Valid Email Address");               
            }
        } 
	}
})