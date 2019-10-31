// material design init
// $(document).ready(function() { $('body').bootstrapMaterialDesign(); });
$(document).ready(function(){

    // header 下拉菜单

    $('.avatar-img').click(function(){
        if(isMobile()) {
            if(typeof mobile_dropdown == 'undefined' || !mobile_dropdown) {

                $('.mobile-dropdown').show();
                mobile_dropdown = true;
            } else {
                $('.mobile-dropdown').hide();
                mobile_dropdown = false;
            }

        }

    })

})

// copy from csdn
function isMobile() {
    var userAgentInfo = navigator.userAgent;

    var mobileAgents = [ "Android", "iPhone", "SymbianOS", "Windows Phone", "iPad","iPod"];

    var mobile_flag = false;

    //根据userAgent判断是否是手机
    for (var v = 0; v < mobileAgents.length; v++) {
        if (userAgentInfo.indexOf(mobileAgents[v]) > 0) {
            mobile_flag = true;
            break;
        }
    }

     var screen_width = window.screen.width;
     var screen_height = window.screen.height;    

     //根据屏幕分辨率判断是否是手机
     if(screen_width < 500 && screen_height < 800){
         mobile_flag = true;
     }

     return mobile_flag;
}


const configMath = () => {
    if (!window.MathJax) {
        window.MathJax = {
            tex2jax: {
                inlineMath: [['\\(', '\\)'], ['$', '$']],
                processEscapes: true
            },
        }

    }
}