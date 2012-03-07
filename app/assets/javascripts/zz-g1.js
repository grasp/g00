/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

//city.js
function get_full_name(code){
    
    if (code.match(/\d\d0000000000$/) )
    {
        selected=$("#float_load2 div div div a[href$="+code+"]")
        selected.css("background-color","#ffcc00");
        return selected.text();
    }
      
    else  if (code.match(/\d\d\d\d00000000$/)  && ( ! code.match(/\d\d0000000000$/)))
    {       
        province_code=code.slice(0,2)+"0000000000"
        $("#float_load2 div div div a[href$="+province_code+"]").css("background-color","#ffcc00");
        $("#float_load2 div div div a[href$="+code+"]").css("background-color","#ffcc00");
        return  $("#float_load2 div div div a[href$="+province_code+"]").text()+ $("#float_load2 div div div a[href$="+code+"]").text();
    }
         
    else if ((! code.match(/\d\d\d\d00000000$/)) && (! code.match(/\d\d0000000000$/)))
    {
        province_code=code.slice(0,2)+"0000000000"
        region_code=code.slice(0,4)+"00000000"
        $("#float_load2 div div div a[href$="+province_code+"]").css("background-color","#ffcc00");
        $("#float_load2 div div div a[href$="+region_code+"]").css("background-color","#ffcc00");
        $("#float_load2 div div div a[href$="+code+"]").css("background-color","#ffcc00");
        return  $("#float_load2 div div div a[href$="+province_code+"]").text()+$("#float_load2 div div div a[href$="+region_code+"]").text()+$("#float_load2 div div div a[href$="+code+"]").text();
    }
    return $("#float_load2 div div div a[href$="+code+"]").text();
}

function city_load(){
    var last_province_code=""
    var new_province_code=""

    $("#from_data_load,#to_data_load" ).live("click",function()
    {
        var coordinate=$("#from_data_load").offset();
        selected= $("#float_load2");
        /*IE not support inherit*/
        //$("#from_data_load,#to_data_load" ).css("background-color","inherit");
        if($("#float_show2").css("display")=="none")
        {
            $("#float_show2").css("display","inline");
            $("form select").css("display","none");
            if($(this).attr("class")=="company_city")
            {
                $("#float_show2").css("top",coordinate.top-630);
                $("#float_show2").css("left",coordinate.left-200);
            }
            else{
                $("#float_show2").css("top",coordinate.top-30);
                $("#float_show2").css("left",coordinate.left);
            }
            
            $("#from_data_load,#to_data_load" ).css("background-color","#D4E4FF");
            $(this).css("background-color","#ffcc00");
            selected.empty();
            selected.load(this.href,function(){
                        
                });
        }
        else
        {
            selected.empty();
            $("#float_show2").css("display","none");
            $("form select").css("display","inline-block");
            
        }
            
        return false;
    });

    $("#float_load2 a.city_province,#float_load2 a.city_region,#float_load2 a.city" ).live("click",function()
    {        
        var last_index=this.href.toString().lastIndexOf('/')
        var code =this.href.toString().substring(last_index+1);
        thishref=this.href
            
        new_province_code=code.slice(0,2)+"0000000000"
        region_code=code.slice(0,4)+"00000000"   
 
        $("#float_load2 div div div a" ).css("background-color","white");
         
        slected=$(this);   
      
        // if same province , do not load
        if (new_province_code!=last_province_code)
        {
            $("#float_load2").css("display","none");
            $("#float_load2").load(this.href,function(){                          
                });
            $("#float_load2").css("display","inline");
        }
      
        if (thishref.match(/cities\/from/))
        {
            $("#selected_city").text(get_full_name(code));
            $("#from_data_load").attr("href",thishref);
            $("#from_data_load").text($("#selected_city").text());
            
            if ($("#search").length >0)
            {
                var action=$("#search").attr("href")
                new_action=action.replace(/search\/\d+/,"search/"+code)
                $("#search").attr("href",new_action)
            }
            else
            {
                $(".fcitycode").val(code);
                $(".fcityname").val($("#selected_city").text());
            //  $("#from_data_load").next().val(code);
            //  $("#from_data_load").next().next().val($("#selected_city").text());
            }
        }

        if (thishref.match(/cities\/to/))
        {
            $("#selected_city").text(get_full_name(code));             
            $("#to_data_load").attr("href",thishref);           
            $("#to_data_load").text($("#selected_city").text());
            if ($("#search").length >0)
            {
                var action2=$("#search").attr("href");            
                lastindex=action2.toString().lastIndexOf('/')
                lastcode =action2.toString().substring(lastindex+1);//fro recover the last number
                new_action=action2.replace(/\/\d+\/\d$/,"/"+code+"/"+lastcode)
                $("#search").attr("href",new_action)
            }
            else
            {
                $(".tcitycode").val(code);
                $(".tcityname").val($("#selected_city").text());
            // $("#to_data_load").next().val(code);
            // $("#to_data_load").next().next().val($("#selected_city").text());
            }
        }
        last_province_code=new_province_code
        return false;
    });

    $("#close1,#close2").live("click",function()
    {
        $(this).parent().parent().css("display","none");
        $("form select").css("display","inline-block");
        return false;
    });

    // for show folat2 classs
    $("a.show_float2,a.baojia" ).live("click",function()
    {
        var coordinate=$(this).offset();
        selected= $("#float_load2");

        $(this).css("background-color","inherit");
        if($("#float_show2").css("display")=="none")
        {
            $("#float_show2").css("display","inline");
            //determin the display location
 
            if($(this).attr("class")=="company_city")
            {

                $("#float_show2").css("top",coordinate.top-300);
                $("#float_show2").css("left",coordinate.left-300);
            }else{
                $("#float_show2").css("top",coordinate.top+30);
                $("#float_show2").css("left",coordinate.left);
            }
      
            $("a.show_float2").css("background-color","inherit");
            $(this).css("background-color","#ffcc00");
            selected.load(this.href);
        //locate the position
        }
        else
        {
            $("#float_show2").css("display","none");
        }

        return false;
    });
    
}


//data_load.js
function general_data_load(){

    //this is for panel data load toggle
    $("a.data_load" ).live("click",function()
    {
        var corordiate= $(this).offset();  
        var parent_coordiate=$(this).parent().parent().offset();
        
        selected=$(this).next();
        $("a.data_load").css("background-color","#D4E4FF");
        $(this).css("background-color","#ffcc00");
        if(selected.css("display")=="none")
        {
            selected.css("display","inline");
            selected.load(this.href);

        }
        else  selected.css("display","none");
        selected.css("top",corordiate.top+$(this).height()+10);
        selected.css("left",corordiate.left -100);
        
        return false;
    });

    $(".data_list div ul li a" ).live("click",function()
    {
        var last_index=this.href.toString().lastIndexOf('/')
        var code =this.href.toString().substring(last_index+1);
        selected=$(this).parent().parent().parent().parent().parent();
        selected.load(this.href);

        selected.prev().text($(this).text());
        $(".data_load").css("background-color","#D4E4FF");
        selected.prev().css("background-color","#ffcc00");
        $(".data_list div ul li a" ).css("background-color","#D4E4FF");
        $(this).css("background-color","#ffcc00");
        selected.next().val(code);
        selected.next().next().val($(this).text());
        return false;
    });

    $(".list_close a").live("click",function()
    {
        $('.data_list').css("display","none");
        return false;
    });
}


//float_load_layer1.js

function request_chenjiao(){
    $("a.request_chenjiao").live("click",function(){
        var answer=confirm("注意:该条货源将改为已成交状态,成交的货源和车源不能再接收新报价，请确保你已经联系并核实过该条车源,对方同意成交后再点击OK .确认请点击OK,取消请点Cancel"); 
        if(answer)
        {
            // $('#show').load(this.href);
            $('#float_load').empty();
            $('#float_show').css("display","none");
            $('tr').css("background-color","white");             
        }
        return false;
                
    });
}

function confirm_chenjiao(){
    $("a.confirm_chenjiao").live("click",function(){
        var answer=confirm("确认成交表示你和货主已经成功协商,货主或将可以评价你提供的服务"); 
        if(answer)
        {
            //  $('#show').load(this.href); 
            $('#float_load').empty();
            $('#float_show').css("display","none");
        }
        return false;
                
    });
}

function float_load_layer1(){

    /* 显示报价 或者询价 子页面 not for form submit ajax*/
    $('a.baojia,a.cargo_fabu,a.truck_fabu,a.show_float').live("click",function(){

       var start=$("#from_data_load").offset();
        var corordiate= $(this).offset();
        var cord_left=corordiate.left;
        var cord_top=corordiate.top;
        selected=$('#float_show')

        var select_parent=$(this).parent().parent();
        var parent_coordiate=select_parent.offset();
        $('tr').css("background-color","white");
       // $('#float_load').empty();
        $('#float_load').load(this.href,function(){
            // stock_cargo_new_validation();
            inquery_new_validation();
            quote_new_validation();
            submit_jubao();
            submit_multiple_emails();   

        });
        css_class= $(this).attr("class");
        if(selected.css("display")=="none")
        {
            selected.css("display","inline");
        }
        else
        {            
            selected.css("display","none");             
        //    selected.css("display","inline");    //????         
        }

        if(select_parent.get(0).nodeName=="TR")
        {
            select_parent.css("background-color","#f7d5bc");
        }
        
        // ajust the location for each float
 
        // if(cord_top>($(".content").offset().top+$(".content").height()/2)+100)
        //   {
        // selected.css("top",$(".content").offset().top);
        //   }
        // else
        //  {
        //      selected.css("top",corordiate.top+30);
        //  }
          
        //   selected.css("left",$("#show").offset().left);
       
        selected.css("left",corordiate.left);

        // if ((this.href.match(/cargos\/show/))||(this.href.match(/trucks\/show/)))
        //  {
        //       selected.css("top",corordiate.top+$(this).height()-30);
        //        selected.css("left",corordiate.left);
        //      }
         
        if ((this.href.match(/quotes/))||(this.href.match(/inqueries/)))
        {
            selected.css("top",corordiate.top+$(this).height()+10);
            selected.css("left",parent_coordiate.left);  
        }
        else
        {
            selected.css("top",corordiate.top+$(this).height()-30);
           selected.css("left",start.left);
          // selected.css("left",10);
                
        }
        
        return false;
    });

    $('a.float_close').live("click",function(){
        $('#float_show').css("display","none");
        $('tr').css("background-color","white");
        return false;
    });


}


//search.js
function line_search()
{

    $('input.cargo_search').live("click",function(){        
        from_city=$('a#from_data_load').attr("href").match(/\d\d\d\d\d\d\d+/)
        to_city=$('a#to_data_load').attr("href").match(/\d\d\d\d\d\d\d+/)
        search_url="/cargos/search/"+from_city+"/"+to_city+"/1"
        // $("#show").load(search_url)
        window.location=search_url
    });
 
    $('input.truck_search').live("click",function(){
        from_city=$('a#from_data_load').attr("href").match(/\d\d\d\d\d\d\d+/)
        to_city=$('a#to_data_load').attr("href").match(/\d\d\d\d\d\d\d+/)
        search_url="/trucks/search/"+from_city+"/"+to_city+"/1"
        // $("#show").load(search_url)
        window.location=search_url

    });
}

function  cargo_myself_click()
{
    $('.cargo_myself').live("click",function(){
        $('.cargo_myself').next().css("display","inline");
        $('.cargo_myself').next().load(this.href);
        return false;
    });
}

function plan_float_show_on_hover()
{
    $('.plan_list,.plan_show').live("mouseover",function() {
        var corordiate= $(this).offset();
        var this_link=$(this).attr("href");
        var this_class=$(this).attr("class");
        var cord_left=corordiate.left;
        var cord_top=corordiate.top;
        myTimeout = setTimeout(function() {

            if (this_class=="plan_list"){
                selected=$('#float_show');
            }
            else
            {
                selected=$('#float_show2');
            }
             
            if(selected.css("display")=="none")
            {
                selected.css("display","inline");
                new_link=this_link+"/layout/true"
                 if (this_class=="plan_list"){
                $('#float_load').empty();           
                $('#float_load').load(new_link,function(){
                    }); }
            else{
                  $('#float_load2').empty();           
                  $('#float_load2').load(new_link,function(){
                    }); 
            }
                    
                selected.css("top",corordiate.top);
            }
            else
            {       
                selected.css("display","none");      
            }
        },1000);
    }).live("mouseout",function() {
        clearTimeout(myTimeout);
    });
    return false;
}

$(document).ready(function() {
    var isfrom=true;
    var old_from=false;
    var from_city_code="330100000000";
    var to_city_code="340000000000";
    var options={
        target:  '#show'
    };   
                
    custermized_validation();
    line_search();
    float_load_layer1();

    request_chenjiao();
    confirm_chenjiao();
    $(".delete").live("click",function()
    {
        var answer = confirm('删除吗？');
        return answer // answer is a boolean
    });
 
    user_new_validation();
    login_validation();
    company_new_validation();
    usercontacts_new_validation();

    stock_cargo_new_validation();
    stock_truck_new_validation();
    cargo_new_validation();
    truck_new_validation();
    stock_truck_update_validation();
    submit_userlines();
    general_data_load();
    city_load();
    plan_float_show_on_hover();
    cargo_myself_click();
    submit_multiple_emails();
    new_concerncargocity();
    $('.dropdown-toggle').dropdown()

    $('.quick_match ').live("click",function(){
        $("#show").load(this.href);
        return false;
    });
    
    url=window.location.pathname;
    if (url.match("/trucks/search")||url.match("/cargos/search")||url.match("/cargos/city")
        ||url.match("/cargos/allcity")||url.match("/trucks/city")||url.match("/trucks/allcity")
        )
        {
        city=window.location.pathname.match(/\d\d/)
        province=city+"0000000000"
        pcity="."+"p"+province
        rcity="div.region_navi >"+" ."+"p"+window.location.pathname.match(/\d\d\d\d/)+"00000000"
        scity="."+"p"+window.location.pathname.match(/\d+/)
        $(pcity).css("background-color","#FAD163");
        $(rcity).css("background-color","#FAD163");
        if (window.location.pathname.match(/\d\d\/city/)){
            $(scity).css("background-color","#FAD163");
        }
    //alert(rcity);
    }
    //change background of selected navi
    $("#navi td").live("click",function(){
        // alert("you click navi");
        $("#navi table tr td").css("background-color","#6a0881");
        $(this).css("background-color","#a249b8");
    });

  
});



