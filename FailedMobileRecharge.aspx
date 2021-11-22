<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="FailedMobileRecharge.aspx.cs" Inherits="FailedMobileRecharge" Title="Untitled Page" %>
<%@ Import Namespace="AccountingEngine" %>
<%@ Import Namespace="TekTravel.Core" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">   
        <link href="yui/build/calendar/assets/calendar.css" type="text/css" rel="stylesheet" />
        <script type="text/javascript" src="yui/build/yahoo/yahoo-min.js"></script>
        <script type="text/javascript" src="yui/build/event/event-min.js"></script>
        <script type="text/javascript" src="yui/build/dom/dom-min.js"></script>
        <script type="text/javascript" src="yui/build/calendar/calendar.js"></script>
        <script type="text/javascript" src="JSLIB\Utils.js"></script>
        <link rel="stylesheet" href="style/tabularstyle.css" type="text/css" />
    <script type="text/javascript" language="javascript">   
 YAHOO.util.Event.addListener(window, "load", init);
var cal1; 
function init()
 {
 var today = new Date();
   cal1 = new YAHOO.widget.Calendar("cal1","callContainer");     
   cal1.selectEvent.subscribe(setDate1);
   cal1.cfg.setProperty("maxDate", (today.getMonth()+1) + "/" + (today.getDate()) + "/" + today.getFullYear());
   cal1.cfg.setProperty("close",true);
   cal1.cfg.setProperty("title", "Date");
   cal1.render();        
 } 
var activeDateBox;
var csvName='';
function StringBuilder(value)
{
    this.strings = new Array("");
    this.append(value);
}

// Appends the given value to the end of this instance.
StringBuilder.prototype.append = function (value)
{
    if (value)
    {
        this.strings.push(value);
    }
}

// Clears the string buffer
StringBuilder.prototype.clear = function ()
{
    this.strings.length = 1;
}

// Converts this instance to a String.
StringBuilder.prototype.toString = function ()
{
    return this.strings.join("");
}
function markin(textBox,txt)
{           
    if(textBox.value==txt)
    {
        textBox.value = "";
    }
    activeDateBox=textBox;            
    ShowCalender('callContainer'); 
}
function markout(textBox, txt)
{           
    if(textBox.value == "")
    {            
        textBox.value = txt;  
    }
}
function AddinList(val, id, retAgencyTypeId)
{
    document.getElementById('AgentName').value=id;
    document.getElementById('AgencyName').value=val;
    document.getElementById('AgencyName1').innerHTML=val +"<a href ='#' onclick='javascript:RemoveFromList();'>Remove</a>"; 
    doNothing();                 
}
function RemoveFromList()
{
    document.getElementById('AgentName').value='';
    document.getElementById('AgencyName').value='';
    document.getElementById('AgencyName1').innerHTML=''; 
    doNothing();                 
}
function ShowCalender(container)
{
    var containerId=container;
    if(document.getElementById(containerId).style.display=="none")
    {
        document.getElementById(containerId).style.display="block"
    }
    var el = $(activeDateBox);
    var top = el.offsetTop;
    var left = el.offsetLeft;
    while(el.offsetParent)
    {
        el = el.offsetParent;
        top += el.offsetTop;
        left += el.offsetLeft;
    }
    document.getElementById(containerId).style.top = top + 16 + "px";
    document.getElementById(containerId).style.left = left + "px";
    if(document.getElementById(containerId).style.display=="none")
    {
        document.getElementById(containerId).style.display="block"
    }
}
function hideDiv(divId)
{
    $(divId).style.display = "none";
}   
function Submit()
     {
        var error="";       
        var fromDate= $('FromDate').value;
		var toDate= $('ToDate').value;
        var dateFormArray = fromDate.split('/');
        var dateToArray = toDate.split('/');         
        var dateFromText = new Date(dateFormArray[2], dateFormArray[1]-1, dateFormArray[0]);           
        var dateToText = new Date(dateToArray[2], dateToArray[1]-1, dateToArray[0]);     
        
        if (!dateDiffAlert(dateFromText,dateToText, fromDate))
        {
        error="To Date Should be Greater than From Date"   ;   
        }
        if(HTMLTagExists(Trim(document.getElementById('<%=txtTransID.ClientID%>').value)))
         {
          error ="Please enter valid Transaction ID";          
         }                 
       if(error=="")
       {        
        document.forms[0].submit();
       }
       else
       {
        alert(error);
       }
     }
function setDate1()
 {
    var date1 = cal1.getSelectedDates()[0];		
    var month = date1.getMonth()+1;
    var day = date1.getDate();
    if (month.toString().length == 1)
    {
      month = "0"+month;
    }
    if (day.toString().length == 1)
    {
      day = "0"+day;
    }
    document.getElementById(activeDateBox.id).value = day + "/" + (month) + "/" + date1.getFullYear();
    document.getElementById('callContainer').style.display="none";			 
}
function ShowCalenderInterface()
{    
 markin($('FromDate'),'DD/MM/YYYY');
}
function ShowCalenderInterface1()
{    
  markin($('ToDate'),'DD/MM/YYYY');
}
function ShowSearchPop()
{
  document.getElementById('SearchPop').style.display="block";
}
function SearchAgent()
{
     var boxvalue = document.getElementById('<% = SearchBox.ClientID %>').value;            
     var url = "AgencyListAjax.aspx?boxtext=" + boxvalue;                
     var id = "AgencyList";
     var myAjax = new Ajax.Updater(id, url, {method: 'post'});
     $(id).innerHTML = '<div class="orange-font">Loading data...</div>';                  
     return true;      
}
function SelectAll(element)
{
    var trackIDString='';
    var count=0;    
    var buttonId ='';
    
    buttonId ='MultipleSaveRecharges';
    
    for(k = 0; k < document.forms[0].elements.length; k++)
    {  // for all elements in form
        f = document.forms[0].elements[k];
        if(f.type == 'checkbox' && f.id != 'Checkbox3' )
        {        
            count++;
 //		 if(!f.checked)
//            {
                f.checked= element.checked;
//            }
        }      
       if(f.type == 'button' &&  f.id.substring(0,13)=='btnIndRefund-' )
        {            
           f.disabled=!f.disabled;
        }  
        $('countCheck').value =count; 
    }  
    if(count!=0)
    {       
        $(buttonId).disabled=!$(buttonId).disabled;    
    } 
}
function CountAllCheckBox()
{
 var count=0;
 for(k = 0; k < document.forms[0].elements.length; k++)
 { 
 f = document.forms[0].elements[k];
 if(f.type == 'checkbox' && f.id.substring(0,9)=='checkBox-' )
 {
    count++;           
 }
 }
 $('totalnocheckbox').value =count; 
}
function HTMLTagExists(data)
{
   var iChars = "<>";
   for (var i = 0; i < data.length; i++) 
       {
       if (iChars.indexOf(data.charAt(i)) != -1) 
           {
               return true;
           }
       }
    return false;
}
function checkcheckbox()
{
 var bool =true;
 var inputs = document.getElementsByTagName("input");
 for (var i = 0; i < inputs.length; i++)
 {    
   if (inputs[i].type == "checkbox" && inputs[i].id.substring(0,9)=='checkBox-')
   {  
     if (inputs[i].checked)
     {
      bool =true;
      break;
     }
     else 
     {
       bool =false;     
     }     
   }
 }
    return bool;
}
function checkvalidate(id)
{  
  var error="";
  if(!$('checkBox-'+id).checked)
  {     
     $('checkBox-'+id).focus();
     error='Please tick the Check box';
  }
  else if(Trim($('TransactionID-'+id).value)=="")
  {
    $('TransactionID-'+id).focus();
     error='Please Enter the TransactionID';
  }
  else if(HTMLTagExists($('TransactionID-'+id).value))
  {
    error='Please Fill the TransactionID without Html tag';
    $('TransactionID-'+id).focus();
  }
   if(error!=="")
   {
    alert(error);
    return false;
   }
   else
   {
   return true;
   }
}   
     
function CheckAllCheckBox(element)
{
    SelectAll(element);
}

 
 function DisableIndButn(id)
 {
  var checkedCount =0;
    var totalCount =0;
    for(k = 0; k < document.forms[0].elements.length; k++)
    {  // for all elements in form
        f = document.forms[0].elements[k];
        if(f.type == 'checkbox' && f.id != 'Checkbox3' )
        {        
            totalCount++;
            if(f.checked)
            {
                checkedCount++;
            }            
        } 
    }  
    
    if(checkedCount == totalCount)
    {
        $('Checkbox3').checked= true;
    }
    else
    {
        $('Checkbox3').checked = false;
    } 
    
    if(checkedCount >0)
    {
        $('MultipleSaveRecharges').disabled = false;
    }
    else
    {
        $('MultipleSaveRecharges').disabled = true;
    }
}
  

function CreateInvoice(id)
{
  var positonarry="",error="";   
  if(Trim($('TransactionID-'+id).value)=="")
  {
    $('TransactionID-'+id).focus();
     error='Please Enter the TransactionID';
  }
  if(HTMLTagExists($('TransactionID-'+id).value))
  {
    error='Please Fill the TransactionID without Html tag';
    $('TransactionID-'+id).focus();
  }
   if(error!=="")
   {
    alert(error);
    $('positionValue').value='';
   }
   else
  {   
 $('positionValue').value=id;
   $('CreateIndInvoice-'+id).disabled=true;  
 document.getElementById('<%=MobileRechargeReportID.ClientID%>').submit();
 }
}
function doNothing()
{
    hideDiv('SearchPop');
    return;        
}

function LoadQueue()
{
    document.getElementById('queueType').value = document.getElementById('ddlRechargeQueue').value;
    document.forms[0].submit();
}

var i;
var rechargeIds='';
function SaveRecharge(rechargeId, index)
{
    $('RefundStatus-'+index).innerHTML ='Saving in progress...';
    $('RefundStatus-'+index).style.display ='block';
    i = index;
    rechargeIds= rechargeId;
    var url = "MobileRechargeAjax.aspx";
    var paramList="rechargeId="+rechargeId+'|';
    paramList +="&MobileSave=true";
    new Ajax.Request(url, {method: 'post', parameters: paramList, onComplete: SaveComplete});
}

function SaveComplete(response)
{
    var responseArr = response.responseText.split('|');
    if(responseArr[0] == '1')
    {
        $('RefundStatus-'+i).innerHTML ='Save Succeeded';
        $('RefundStatus-'+i).style.display ='block';
        $('RefundBlock-'+i).innerHTML ='';
//        $('RefundBlock-'+i).innerHTML ='<a href="MobileRechargeCreditNote.aspx?rechargeId='+rechargeIds+' style="padding-right: 0">View Credit Note</a>';
    }
    else
    {
        $('RefundStatus-'+i).innerHTML ='Save Failed';
        $('RefundStatus-'+i).style.display ='block';
        $('RefundBlock-'+i).style.display ='block';
   }    
}

function SaveSelectedRecharges()
{
    var rechargeId='';
    for(k = 0; k < document.forms[0].elements.length; k++)
    {  
        f = document.forms[0].elements[k];
        if(f.type == 'checkbox' && (f.id.substring(0,11)=='chkIndSave-') && f.checked )
        {                    
            rechargeId+=f.id.split('-')[1]+'|';
        }              
    }  
    
    $('RefundStatus').innerHTML ='Saving in progress...';
    $('RefundStatus').style.display ='block';
    var url = "MobileRechargeAjax.aspx";
    var paramList="rechargeId="+rechargeId;
    paramList +="&MobileSave=true";
    new Ajax.Request(url, {method: 'post', parameters: paramList, onComplete: SaveSelectedRechargesComplete});
    
}

function SaveSelectedRechargesComplete()
{
    document.forms[0].submit();
}

function ShowPage(pageNo)
{
    $('PageNoString').value=pageNo;
    //alert($('PageNoString').value);
    document.forms[0].submit();
}

</script>     
        <!--Mobile Recharge Report start here !-->        
    <form id="MobileRechargeReportID"  name="MobileRechargeReportID" runat="server"  >
        <div><input id="positionValue" name="positionValue" type="hidden" /> 
        <input  id="countCheck" name="countCheck" type="hidden" />  
          <input  id="totalnocheckbox" name="totalnocheckbox" type="hidden" /> 
          <input type="hidden" name="transactionIdString" id="transactionIdString" value="" />
          <input type="hidden" name="ipAddr" id="ipAddr" value='<%=ipAddr %>' />      
        </div>        
        <div class="mobileRr_container">
            <h1>
                <span>Pending Mobile/DTH Recharge</span></h1>    
       <div class="tab-main-box">
            <ul>
                <%--<li ><a href="PendingMobileRecharge.aspx">Recharge Status</a></li>--%>
                <li class="selected-tab"><a href="FailedMobileRecharge.aspx">Pending Recharges</a></li>
                <li ><a href="RefundMobileRecharge.aspx">Refund Recharges</a></li>
            </ul>
            
        </div>         
            <div class="status-wrap">

                <div class="daterange">
                
               
                    <span class="bold wd1">Search For Agent:</span> <span><a href="javascript:ShowSearchPop()">
                        Select Agent</a></span>
                    <br />
                    <input id="AgentName" class="width-163" name="AgentName" type="hidden" />
                    <div class="margin-top-10 bold" id="AgencyName1" = "AgencyName1">
                    </div>
                    <input type="hidden" id="AgencyName" name="AgencyName" />
                </div>
                <div class="daterange2">
                    <span class="bold wd3" style="width:110px; word-wrap:break-word;">TransactionId(TBO/Supplier)</span> <span>
                    <asp:TextBox ID="txtTransID" runat="server" /></span>
                </div>
            </div>             
            <div class="status-wrap">
                <div class="daterange">
                    <span class="bold wd1">From</span> <span>
                        <input type="text" id="FromDate" readonly="readonly" value="DD/MM/YYYY" name="FromDate"
                            class="" onblur="markout(this,'DD/MM/YYYY')" onfocus="markin(this,'DD/MM/YYYY')" />
                        <img src="images/cal.gif" alt="" onclick="ShowCalenderInterface()" /></span>
                    <div id="callContainer" style="display: none; position: absolute; width: 150px;">
                    </div>
                </div>
                <div class="daterange2">
                    <span class="bold wd3" style="width:110px;">To</span> <span>
                        <input type="text" id="ToDate" readonly="readonly" value="DD/MM/YYYY" name="ToDate"
                            class="" onblur="markout(this,'DD/MM/YYYY')" onfocus="markin(this,'DD/MM/YYYY')" />
                        <img src="images/cal.gif" alt="" onclick="ShowCalenderInterface1()" /></span>
                </div>
                <div class="clr mobileRechargebuttons">
                                <input type="button" value="show" onclick="Submit();" />                                   
                                <a href="FailedMobileRecharge.aspx"> Clear Filters</a>                         
                </div>
            </div>
        </div>
        <div id="SearchPop" class="all_Agency_pop_up" style="display:none; left: 374px; top: 188px;">
            <div class="serachContainer center">
                <span><b>Search</b></span> <span class="margin-left-10">
                    <asp:TextBox ID="SearchBox" runat="server" CssClass="text" Text="" Width="185px"></asp:TextBox>
                </span><span class="margin-left-5">
                    <input type="button" name="AgentSearch" id="AgentSearch" value="Search" onclick="javascript:SearchAgent();" />
                </span><span class="hand margin-left-5" onclick="hideDiv('SearchPop')">
                    <img alt="close" src="Images/close.gif" /></span></div>
               <div id="AgencyList" class="agency_pop_up_list" >
              </div>        
            </div>
            <div  style="display:<% =displayerr%>; font-weight:bold; color:red; padding-top:10px; text-align:center;" ><asp:Label ID="lblerr" runat="server" ></asp:Label><label style="font-weight:bold; color:Green;" ><%=SuccesMsg %></label></div>
        <!-- //Mobile Recharge Report start here !-->
        <div>
        
        <input type="hidden" id ="PageNoString" value="1" name="PageNoString" />
        
        <div class="fleft italic margin-top-20 font-14" style="margin-left: 90px; margin-top: 50px; display:none" id ="RefundStatus"></div>
                        
        <div class="fleft margin-top-15 width-100">
                <% if ((lstMobileRecharges == null) || (lstMobileRecharges.Count <= 0))
               {%>
                <div class="fleft italic margin-top-20 font-14" style="margin-left: 90px; margin-top: 50px">
                    There are no recharges to be saved.
                </div>
                <%}%>
                <%else
                    { %>
                    <div style="width:100%;">
                        <%=show %>
                        <div class="heading-tbd fleft margin-right-10 blueclr" ></div> 
                         </div>
                <div class="tabulardata-wraper">
                    <table class="tabular-data"  width="1150" border="0">
                        <thead>
                            <tr>                           
                                <th width="30">S.No.</th>                               
                                <th width="120">Recharge Date</th>
                                <th width ="60">Service</th>                               
                                <th width="100">Mobile/DTH No.</th>
                                <th width="80">Amount</th>  
                                <th width="130">Status</th>                              
                                <th width="180">AgencyName</th>
                                 <th width="130">SubAgencyName</th>                                    
                                <th width="150">TransactionId</th>  
               <%--                  <th width="160" >Supplier TransactionId</th> --%>                                                          
                                <th width="150"> 
                                  <span class="fleft margin-left-10"><input type="checkbox" id="Checkbox3" name="CheckAll"  onclick="javascript:CheckAllCheckBox(this)"/></span><span class="fleft margin-left-5">Check All</span></th>
                            </tr>
                        </thead>
                        <tbody>
                        
                            <% for (int i = 0; i < lstMobileRecharges.Count; i++)
                               {
                                   string bgcolor = string.Empty;
                                   if (i % 2 == 0)
                                   {
                                       bgcolor = "background-color: white;";
                                   }
                                   else
                                   {
                                       bgcolor = "background-color: #F4F5F7;";
                                   }    
                             %>                              
                            <tr style="<%=bgcolor %>" >                            
                              <td><%=(recordsPerPage * (pageNo - 1) +i+1)%>                                
                                
                             </td>
                                <input type="hidden" id="hidRechargeId-<%=i %>" name="hidRechargeIds-<%=i %>" value="<%=lstMobileRecharges[i].RechargeId %>" />
<%--                                <input type="hidden" id="hidFailedBookingId-<%=i %>" name="hidFailedBookinId-<%=i %>" value="<%=lstMobileRecharges[i].MobileFailedBookingId %>" />
--%>                                <td> <%=lstMobileRecharges[i].CreatedOn.Add(new TimeSpan(5, 30, 0)).ToString("dd/MM/yyyy hh:mm:ss")%></td>
                                <td> <%=lstMobileRecharges[i].Service%></td>
                                <td><%=lstMobileRecharges[i].MobileNumber%></td>
                                <td><%=lstMobileRecharges[i].Amount%></td>
                                <td>
                                   <%if (lstMobileRecharges[i].Status != TekTravel.BookingEngine.MobileStatus.VOID)
                                     {
                                         Response.Write(lstMobileRecharges[i].Status);
                                     }
                                     else
                                     {
                                         Response.Write(TekTravel.BookingEngine.MobileStatus.PENDING);
                                     }
                                   %>
                                   
                                  
                                </td>
                                <%
                                   TekTravel.Core.Agency agency = new Agency();
                                   agency.Load(lstMobileRecharges[i].AgencyId);
                                %>                              
                                <td><%= agency.AgencyName %><input type="hidden" id="Hidden2" name="AgencyID-<%=i%>" value='<%=agency.AgencyId%>' /></td>
                                <% if (lstMobileRecharges[i].B2b2bSubAgencyId > 0 && lstMobileRecharges[i].B2B2BSubAgencyName != null && lstMobileRecharges[i].B2B2BSubAgencyName.Length > 0)
                                   { %>
                                 <td>  <%= lstMobileRecharges[i].B2B2BSubAgencyName%> </td>
                                <%} else { %>
                                <td> </td>  
                                <%} %>
                                 <td><%string txnId = !string.IsNullOrEmpty(lstMobileRecharges[i].TransactionId) ? lstMobileRecharges[i].TransactionId : lstMobileRecharges[i].ClientId; Response.Write(txnId);%> </td>
                                 <%-- <td><%=lstMobileRecharges[i].TransactionId %> </td>--%>
                               <td > 
                               <span id="RefundBlock-<%=i %>">
                                  <span class="fleft margin-left-10 margin-top-5"><input id="chkIndSave-<%=lstMobileRecharges[i].RechargeId %>" name="checkBox-<%=lstMobileRecharges[i].RechargeId %>"  type="checkbox" onclick="DisableIndButn('<%=i%>')"  /></span>  
                                  <span class="fleft margin-left-5"><input type="button"   class="button_clr"  id="btnIndRefund-<%=i %>"  onclick="SaveRecharge('<%=lstMobileRecharges[i].RechargeId %>' ,'<%=i %>')" value="Save" /></span> 
                               </span>
                                  <span class="fleft margin-left-5" id="RefundStatus-<%=i %>" style="display:none"></span>
                               </td>
                            </tr>                            
                            <% }   } %>
                        </tbody>
                    </table>
                </div>
                 <% if ((lstMobileRecharges != null) && (lstMobileRecharges.Count > 0))
                    {%>
                <div class="fright margin-top-8">
                <input type="button" id="MultipleSaveRecharges" disabled="disabled"  onclick="javascript:SaveSelectedRecharges();" value="Save All Recharges" />
            </div>
            <%} %>
        </div>

        </div>        
        <% if (Request["AgentName"] != null && Request["AgentName"].Length > 0)
               { %>
        <script type="text/javascript">
             $('AgentName').value = '<%=Request["AgentName"].Replace("'","\\'")%>';
             $('AgencyName1').innerHTML = '<%=Request["AgencyName"].Replace("'","\\'")%>'+ '<a href =\'#\' onclick=\'javascript:RemoveFromList();\'>Remove</a>';
             $('AgencyName').value= '<%=Request["AgencyName"].Replace("'", "\\'")%>';
        </script>

        <% }  %>
        <%  if (Request["FromDate"] != null && Request["FromDate"].Length > 0)
                  { %>

        <script type="text/javascript">
             $('FromDate').value = '<%=Request["FromDate"]%>';
        </script>

        <% } %>
        <%  if (Request["ToDate"] != null && Request["ToDate"].Length > 0)
                { %>

        <script type="text/javascript">
             $('ToDate').value = '<%=Request["ToDate"]%>';
        </script>

        <% } %>
    </form>
</asp:Content>