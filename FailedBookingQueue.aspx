<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FailedBookingQueue.aspx.cs"
    Inherits="FailedBookingQueue" MasterPageFile="~/MasterPage.master" %>
<%@ Import Namespace="TekTravel.BookingEngine" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">

    <script src="JSLib/ModalPop.js" type="text/javascript"></script>
    
     <script type="text/javascript">
 function Errormsg(i)
 { 
    $j(document).ready(function(){
    $j("#popErr"+i).show();
    $j("#close"+i).click(function(){
        $j("#popErr"+i).hide(); 
        });
 })  
};
 function PaymentDetails(i)
 { 
    $j(document).ready(function(){
    $j("#paymentDetails"+i).show();
    $j("#closes"+i).click(function(){
        $j("#paymentDetails"+i).hide(); 
        });
 })  
};
</script>

    <script type="text/javascript">
     function ConfirmDelete(index)
     {
        $('selectedIndex').value = index;
        ModalPop.AcceptButton.value = "OK";
        ModalPop.DenyButton.onclick = CancelDelete;
        ModalPop.DenyButton.value = "Cancel";
        ModalPop.AcceptButton.onclick = Delete;
        var modalMessage = "<div>This will remove the record. Are you sure to proceed? If so then please enter the reason.</div><div style=\"margin-top:15px;text-align:left\">Remarks: <textarea id=\"RemarksBox\" name=\"RemarksBox\" cols=\"35\" rows=\"3\"></textarea> <div style=\"font-size:10px;font-style:italic;margin-left:100px\"></div>";
        ModalPop.Show({x: 400, y: 200}, modalMessage);
     }
     function Delete()
     {
        ModalPop.AcceptButton.disabled = true;
         ModalPop.DenyButton.disabled = true;
         var index = $('selectedIndex').value;
         $('remarks').value = $('RemarksBox').value;
         var page = "AjaxHandler.aspx";
         var pars = "remarks=" + $('RemarksBox').value;
         pars += "&failedBookingId=" + $('failedBookingId-' + index).value;
         pars += "&action=RemoveFaildBookingFromQueue";
            new Ajax.Request(page, {method: 'post', parameters: pars, onComplete: DisplayMessage});
      
        }
        function DisplayMessage(response) {
            var index = $('selectedIndex').value;
             $('div_Error').html = "";
            if (response != '') {
                if (response.responseText == 'success') {
                    $('DisplayPNR' + index).style.display = 'none';
                    CancelDelete();
                    $('div_Error').html = response.responseText;
                }
                else {
                    $('div_Error').html = "";
                    CancelDelete();
                }
            }
        }
    function CancelDelete()
    {
        ModalPop.Hide();
    }
    function GetDetails(i)
    {
       $('DisplayPNR'+i).submit();
    }
    </script>

    
    <div class="fleft margin-top-10 padding-left-10 width-890">
        <form id="searchForm" method="post" action="failedbookingqueue.aspx">
             <input type="hidden" name="selectedIndex" id="selectedIndex" value="" />
        <span class="fleft"><b class="margin-left-10">PNR</b><input id="inputPNRsearch" name="inputPNRsearch" class="width-90 margin-left-5" type="text" value="<%=Request["inputPNRsearch"] %>"/></span>
        <%if (Convert.ToInt32(Session["agencyId"]) == 0)
          { %>
            <span class="fleft"><b class="margin-left-10">Agency Name</b><input id="inputAgencyName" name="inputAgencyName" class="width-90 margin-left-5" type="text" value="<%=Request["inputAgencyName"] %>" /></span>
          <%} %>
        <span class="fleft"><b class="margin-left-10">Airline</b><input id="inputAirline" name="inputAirline" type="text" class="width-90 margin-left-5" value="<%=Request["inputAirline"] %>"/></span>
        <span class="fleft"><b class="margin-left-10">Pax Name</b><input id="inputPaxName" name="inputPaxName" type="text"  class="width-90 margin-left-5" value="<%=Request["inputPaxName"] %>" /></span>
        <span class="fleft"><b class="margin-left-10">Transaction Id</b><input id="inputTxnId" name="inputTxnId" type="text"  class="width-90 margin-left-5" value="<%=Request["inputTxnId"] %>" /></span>
        <span class="fleft"><b class="margin-left-10">Status</b>
        <select id="bStatus" name="bStatus">
        <option value="">--Select--</option>
           <%foreach (Status val in Enum.GetValues(typeof(Status)))
             {
                 if (Request["bStatus"] != null && Request["bStatus"] != "")
                 {%>
                    <%if (Convert.ToInt32(Request["bStatus"]) == (int)val) 
                      {%>
                        <option value="<%=(int)val %>" selected="selected" ><%=val%></option>
                     <%}
                      else
                      { %>
                        <option value="<%=(int)val %>"><%=val%></option>
                      <%} %>
                    
              <% }
                 else
                 {%>
                    <option value="<%=(int)val %>"><%=val%></option>
                <%}
            }%>
        </select>
        </span>
        <span class="fleft"><b class="margin-left-10">BookingMode </b>
        <select id="bMode" name="bMode">
        <option value="">--Select--</option>
         <%foreach (BookingMode val in Enum.GetValues(typeof(BookingMode)))
           {
               if (val == BookingMode.Auto || val == BookingMode.B2B2B || val == BookingMode.NotSet|| val ==BookingMode.WhiteLabel|| val == BookingMode.BookingAPI||val ==BookingMode.Manual)
               {
                   if (!String.IsNullOrEmpty(Request["bMode"]))
                   {%>
                    <%if (Convert.ToInt32(Request["bMode"]) == (int)val)
                      {%>
                        <option value="<%=(int)val %>" selected="selected" ><%=val%></option>
                     <%}
                       else
                       { %>
                        <option value="<%=(int)val %>"><%=val%></option>
                      <%} %>
                    
              <% }
                 else
                 {%>
                    <option value="<%=(int)val %>"><%=val%></option>
                <%}
              }
          }%>
         </select>
         </span>
        <span class="fright width-130 margin-top-8 padding-right-10">
            <a href="failedbookingqueue.aspx" class="font10 margin-top-5 fright">Clear Filters</a>
            <input type="submit" name="search" id="search" value="" class="search-hotel-budget fleft" style="width:50px;" />
         </span>
         </form>
         </div>
         <div class="fleft width-100">
   
        <% if ((fblist == null || fblist.Count == 0))
           {%>
        <span class="fleft red font-14 padding-left-20">
            There is no Pending Booking in the Queue
        </span>
        <%}%>
          
    </div>
        <%if (fblist !=null && fblist.Count > 0)
      {%>
   
        <div class="fleft  width-100">
            <%if (fblist.Count <=recordsPerPage)
            {%>
                <%= show%>
            <%} %> 
        </div>
        <div class="width_100" style="float: left; padding:5px;">
          
            <div id="div_Error" style="margin-left: 90px;  margin-top: 50px; color: Red;">
                <%=errorMessage%>
            </div>
            <div class="fleft margin-top-10">
                <div class="fleft font-14 bold width-90">
                    PNR</div>
                <div class="fleft margin-left-10 font-14 bold width-90">
                    Created On</div>
                <div class="fleft margin-left-35 font-14 bold width-190">
                    Agency Name</div>
                <div class="fleft margin-left-5 font-14 bold width-150 center">
                    Details</div>
                <div class="fleft margin-left-30 fleft font-14 bold width-90">
                    Source</div>
                <div class="fleft font-14 margin-left-10 bold width-80">
                    Status</div>
                <div class="fleft font-14 margin-left-10 bold width-150">
                    Booking Mode</div>
            </div>
        </div>
   
    <%} %>
    <div>
        <%  
            for (int i = 0; (fblist != null && i< fblist.Count); i++)
            {

                string actionPage = "DisplayPNRInformation.aspx";
                if (string.IsNullOrEmpty(fblist[i].PNR))
                {
                    actionPage = "DisplayPNR.aspx";
                }

        %>
        <div class="corner-block-parent fleft width_100 relative" style="border-bottom-width: thin;">
            <div class="width_100 padding-10 fleft box_sizing">
                <form action="<%=actionPage %>" method="post" id="DisplayPNR<%=i %>" style="display: inline">
                <input type="hidden" name="isFailed" value="true"/>
                    <div class="fleft font-14  width-85">
<%--                      <div id="Div1" class="popErr popErr_failbq">
                            <a href="#null" id="A2" class="acls">X</a>
                            <div class="hrpp">ErrorMsg</div>
                            <div class="padding-5"><%=fblist[i].ErrorMsg%></div>
                        </div>--%>
                        <%if(!string.IsNullOrEmpty(fblist[i].PNR))
                        {%>
                            <%=fblist[i].PNR%>
                       <%}
                        else
                        {%>
                            N/A
                      <%} %>
                    </div>
                    <div class="fleft   margin-left-30 width-90">
                        <%=Utility.UTCtoISTtimeZoneConverter(Convert.ToString(fblist[i].CreatedOn)).ToString("dd/MM/yyyy HH:mm:ss")%>
                    </div>
                    <%-- <%TekTravel.Core.Agency a=new TekTravel.Core.Agency(fblist[i].AgencyId); %>--%>
                    <div class="fleft margin-left-20 width-150">
                        <%=fblist[i].AgencyName%>
                    </div>                   
                    <div class="fleft margin-left-20  width-200 center">
                   
                    <%=(fblist[i].BookingDetails.Trim() != string.Empty) ?fblist[i].BookingDetails.Trim() : "N/A" %></div>
                    <div class="fleft margin-left-10  width-90">
                        <%=fblist[i].Source%>
                    </div>
                    <div class="fleft margin-left-10  width-90">
                        <%=fblist[i].CurrentStatus%>
                    </div>
                     <div class="fleft margin-left-10  width-90">
                           <%if (fblist[i].BookingMode != 0)
                          {%> <%=fblist[i].BookingMode%> <%}
                              else
                              { %> NotSet <% } %>
                    </div>
                    <input type="hidden" id="j" value="<%=j %>" />
                    <%--<input type="submit" value="Get Details" />--%>
                    <div class="fright width_100 align-right">
                   
                     <%if (fblist[i].ErrorMsg != null && fblist[i].ErrorMsg.Trim() != "")
                          {%>
                        <a  href="javascript:Errormsg(<%=i %>)" id="apopErr<%=i %>">ErrorMsg</a>
                        <% } %>
                        <%if (fblist[i].BookingMode == BookingMode.B2B2B || fblist[i].BookingMode == BookingMode.WhiteLabel || fblist[i].BookingMode == BookingMode.BookingAPI) 
                         { %>
                         <a  href="javascript:PaymentDetails(<%=i %>)" id="paymentDetail<%=i %>" >PaymentDetails</a>
                        
                       <% } %>
                        
                    <input type="hidden" id="failedBookingId-<%=i%>" name="failedBookingId-<%=i%>" value="<%=fblist[i].FailedBookingId %>" />
                    <%if (fblist[i].CurrentStatus != TekTravel.BookingEngine.Status.Removed)
                    { %>      
                        <a class="comon_btn" style="padding:2px" href="javascript:ConfirmDelete(<%=i%>)">Remove</a>
                    <% } %>
                         <a class="comon_btn" style="padding:2px"  href="javascript:GetDetails(<%=i %>)">Open</a>
                        </div>
                      <div id="popErr<%=i %>" class="popErr popErr_failbq">
                            <a href="#null" id="close<%=i %>" class="acls">X</a>
                            <div class="hrpp">ErrorMsg</div>
                            <div class="padding-5" style="word-wrap:break-word;"><%=fblist[i].ErrorMsg%>
                            </div>
                        </div>
                        <div id="paymentDetails<%=i %>" class="popErr popErr_failbq ">
                            <a href="#null" id="closes<%=i %>" class="acls">X</a>
                            <div class="hrpp">PaymentDetails</div>
                            <div class="padding-5">
                             <%if (fblist[i].BookingMode == BookingMode.B2B2B)
                              { %>
                                    <span><label>TransactionId:</label><em> <%= fblist[i].TransactionId %> </em></span><br/>
                             <%}
                             else
                             {%>
                                <span><label>PaymentId:</label><em> <%= fblist[i].PaymentId %> </em></span><br/>
                                <span><label>PaymentSource:</label><em>  <%= fblist[i].PaySource %> </em></span><br/>
                                <span><label>PaymentAmount:</label><em> <%= fblist[i].PaymentAmount %> </em></span><br/>
                                <%if (fblist[i].PaymentId != null && fblist[i].PaymentId.Contains("B2B2B")) 
                                  { %>
                                <span><label>TicketAmount:</label><em> <%= fblist[i].PaymentAmount%> </em></span><br/>
                               <% }
                                  else
                                  { %>
                                <span><label>TicketAmount:</label><em> <%= fblist[i].TicketAmount%> </em></span><br/>
                                <%} %>
                            <%} %>
                            </div>
                        </div>
                    <input type="hidden" name="pnrNo" value="<%=fblist[i].PNR %>" />
                    <input type="hidden" name="failedBookingId" value="<%=fblist[i].FailedBookingId %>" />
                    <% string []bookingDetailSplit =fblist[i].BookingDetails.Split( new[] { "<br />" }, StringSplitOptions.RemoveEmptyEntries);
                        //e.g booking detail - DEL - LON<br />Dept: 11 Jul 2020<br />Return: 21 Jul 2020<br />Mr FEUXZHJOF tbo<br />LH
                        string[] nameSplit = bookingDetailSplit[bookingDetailSplit.Length-2].Split(' ');
                        string lastName =   nameSplit[nameSplit.Length-1];     // last name is used in aircosta and bhutan airline import  
                %>
                    <input type="hidden" name="lastName" value="<%= lastName %>" />
                    <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.Amadeus)
                      { %>
                    <input type="hidden" name="source" value="1A" />
                    <% }%>
                    <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.Abacus)
                      { %>
                    <input type="hidden" name="source" value="1B" />
                    <% }%>
                     <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.FlyDubai)
                      { %>
                    <input type="hidden" name="source" value="FZ" />
                    <% }%>
                    <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.WorldSpan)
                      { %>
                    <input type="hidden" name="source" value="1P" />
                    <% }%>
                    <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.Galileo)
                      { %>
                    <input type="hidden" name="source" value="1G" />
                    <% }%>
                    <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.SpiceJet)
                      { %>
                    <input type="hidden" name="source" value="SG" />
                    <% }%>
                    <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.Indigo)
                      { %>
                    <input type="hidden" name="source" value="6E" />
                    <% }%>
                    <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.Paramount)
                      { %>
                    <input type="hidden" name="source" value="I7" />
                    <% }%>
                    <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.AirDeccan)
                      { %>
                    <input type="hidden" name="source" value="DN" />
                    <% }%>
                    <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.Mdlr)
                      { %>
                    <input type="hidden" name="source" value="9H" />
                    <% }%>
                    <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.GoAir)
                      { %>
                    <input type="hidden" name="source" value="G8" />
                    <% }%>
                    <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.Sama)
                      { %>
                    <input type="hidden" name="source" value="ZS" />
                    <% }%>
                    <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.AirIndiaExpress)
                      { %>
                    <input type="hidden" name="source" value="IX" />
                    <% }%>
                    <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.AirAsia)
                      { %>
                    <input type="hidden" name="source" value="AK" />
                    <% }%>
                    <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.AirAsiaTBF)
                      { %>
                    <input type="hidden" name="source" value="AKA" />
                    <% }%>
                    <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.Picasso)
                      { %>
                    <input type="hidden" name="source" value="1C" />
                    <% }%>
                    <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.TravelFusion)
                      { %>
                    <input type="hidden" name="source" value="IL" />
                    <% }%>
                     <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.AirCosta)
                      { %>
                    <input type="hidden" name="source" value="LB" />
                    <% }%>
                    <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.BhutanAirlines)
                      { %>
                    <input type="hidden" name="source" value="B3" />
                    <% }%>
                    <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.AirPegasus)
                      { %>
                    <input type="hidden" name="source" value="OP" />
                    <% }%>
                    <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.TruJet)
                      { %>
                    <input type="hidden" name="source" value="2T" />
                    <% }%>
                      <%if (fblist[i].Source == TekTravel.BookingEngine.BookingSource.AirArabia)
                      { %>
                    <input type="hidden" name="source" value="G9" />
                    <% }%>
                     <%if (fblist[i].Source == BookingSource.FlyScoot)
                      { %>
                    <input type="hidden" name="source" value="TZ" />
                    <% }%>
                    <%if (fblist[i].Source == BookingSource.NokScoot)
                      { %>
                    <input type="hidden" name="source" value="XW" />
                    <% }%>
                     <%if (Util.IsSpiceJetSubAirline(fblist[i].Source) || Util.IsIndigoSubAirline(fblist[i].Source) ||
                           Util.IsGoAirSubAirline(fblist[i].Source) || Util.IsAirPegasusSubAirline(fblist[i].Source))
                      { %>
                    <input type="hidden" name="source" value="<%=Util.GetAliasAirlineCode(fblist[i].Source) %>" />
                    <% }%>
                     <%if (fblist[i].Source == BookingSource.ZoomAir)
                      { %>
                    <input type="hidden" name="source" value="ZO" />
                    <% }%>
                    <%if (fblist[i].Source == BookingSource.Pyton)
                      { %>
                    <input type="hidden" name="source" value="PY" />
                    <% }%>
                    <%if (fblist[i].Source == BookingSource.TBOAir)
                      { %>
                    <input type="hidden" name="source" value="TBA" />
                    <% }%>
                    <%if (fblist[i].Source == BookingSource.BritishAirways)
                      { %>
                    <input type="hidden" name="source" value="BA" />
                    <% }%>
                    <%if (fblist[i].Source == BookingSource.OmanAir)
                      { %>
                    <input type="hidden" name="source" value="WY" />
                    <% }%>
                    <%if (fblist[i].Source == BookingSource.Lufthansa)
                      { %>
                    <input type="hidden" name="source" value="LH" />
                    <% }%>
                    <%if (fblist[i].Source == BookingSource.SingaporeAirline)
                      { %>
                    <input type="hidden" name="source" value="SQ" />
                    <% }%>
                    <%if (fblist[i].Source == BookingSource.Flynas)
                      { %>
                    <input type="hidden" name="source" value="XY" />
                    <% }%>
                    <%if (fblist[i].Source == BookingSource.Jazeera)
                      { %>
                    <input type="hidden" name="source" value="J9" />
                    <% }%>
                    <%if (fblist[i].Source == BookingSource.StarAir)
                      { %>
                    <input type="hidden" name="source" value="OG" />
                    <% }%>
                     <%if (fblist[i].Source == BookingSource.FlyBig)
                      { %>
                    <input type="hidden" name="source" value="S9" />
                    <% }%>
                <%if (fblist[i].Source == BookingSource.AmadeusNDC)
                  { %>
                    <input type="hidden" name="source" value="1A-NDC" />
                <% }%>
                    <%if (fblist[i].Source == BookingSource.Saudia )
                      { %>
                    <input type="hidden" name="source" value="SV" />
                    <% }%><%if (fblist[i].Source == BookingSource.OmanAir)
                      { %>
                    <input type="hidden" name="source" value="WY" />
                    <% }%><%if (fblist[i].Source == BookingSource.SalamAir)
                      { %>
                    <input type="hidden" name="source" value="OV" />
                    <% }%>
                    <%if (fblist[i].Source == BookingSource.Emirates)
                      { %>
                    <input type="hidden" name="source" value="EK" />
                    <% }%>
                    <%if (fblist[i].Source == BookingSource.InterSky)
                      { %>
                    <input type="hidden" name="source" value="3L" />
                    <% }%>
                    <input type="hidden" name="AdminId" id="Hidden4" value="<%= AdminId %>" />
                    <input type="hidden" name="BookingAgencyID" value="<%= fblist[i].AgencyId %>" />
                </form>
                <form action="FailedBookingQueue.aspx" method="get" style="display: inline" id="RemoveForm-<%=i%>">
                    <input type="hidden" name="pnr" value="<%=fblist[i].PNR %>" />
                    <input name="postback" type="hidden" value="remove" />
                    <input name="pageNo" type="hidden" value="<%=pageNo %>" />
                    <input type="hidden" name="remarks" value="" id="remarks"/>
                    <%--<input type="hidden" id="failedBookingId-<%=i%>" name="failedBookingId" value="<%=fblist[i].FailedBookingId %>" />
                    <%if (fblist[i].CurrentStatus != TekTravel.BookingEngine.Status.Removed)
                    { %>      
                        <a class="comon_btn" href="javascript:ConfirmDelete(<%=i%>)">Remove</a>
                    <% } %>--%>
                </form>
            </div>
        </div>
        <% } %>
    </div>
</asp:Content>
