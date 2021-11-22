using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using TekTravel.BookingEngine;
using TekTravel.Configuration;
using TekTravel.Core;
using System.Collections.Generic;

public partial class FailedMobileRecharge : System.Web.UI.Page
{
    protected Nullable<DateTime> startDate = null;
    protected Nullable<DateTime> endDate = null;
    protected int agencyId = 0;
    protected DataTable MobileRechargeData;
    protected string TranscationID = null;
    protected string displayerr = "none";
    protected int AdminId = 1;
    protected string Status = "2";
    protected string SuccesMsg = string.Empty;
    protected string ipAddr = "";
    //protected List<MobileFailedBooking> lstMobileFailedBookings = new List<MobileFailedBooking>();
    protected List<MobileRechargeItinerary> lstMobileRecharges = new List<MobileRechargeItinerary>();

    protected int recordsPerPage = Convert.ToInt32(ConfigurationSystem.PagingConfig["FailedBookingQueueRecordsPerPage"]);
    protected string show = string.Empty;
    protected int pageNo = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        AuthorizationCheck();
        Title = "Failed Mobile Recharge";
        ipAddr = TekTravelCore.Audit.GetClientIPAdd();


        int lower = 0;
        int upper = 0;
        int rowCount = 0;
        int noOfPages = 0;

        displayerr = "block";

        pageNo = 0;

        try
        {
            if (Request["PageNoString"] != null)
            {
                pageNo = Convert.ToInt32(Request["PageNoString"]);
            }
            else
            {
                pageNo = 1;
            }
            lower = (pageNo * recordsPerPage) - (recordsPerPage - 1);
            upper = pageNo * recordsPerPage;


            setFilters();

            //rowCount = MobileFailedBooking.GetCount(agencyId, startDate, endDate, TranscationID);
            //lstMobileFailedBookings = MobileFailedBooking.GetAllFailedBooking(lower, upper, agencyId, startDate, endDate, TranscationID);



            //rechargeHistory = MobileRechargeItinerary.GetRecordsOnFilterBasis(lower, upper, filter, filterText, Convert.ToInt32(Session["agencyID"]), type);
            //rowCount = MobileRechargeItinerary.GetTotalNoOfFilteredRecords(filter, filterText, agencyId);

            rowCount = MobileRechargeItinerary.GetActionRowCount(agencyId, startDate, endDate, TranscationID);
            lstMobileRecharges = MobileRechargeItinerary.GetActionMobileRecords(lower, upper, agencyId, startDate, endDate, TranscationID);


            string url = "FailedMobileRecharge.aspx?";
            if ((rowCount % recordsPerPage) != 0)
            {
                noOfPages = (rowCount / recordsPerPage) + 1;
            }
            else
            {
                noOfPages = (rowCount / recordsPerPage);
            }
            show = Utility.PagingJavascript(noOfPages, url, pageNo);
        }

        catch (Exception ex)
        {
            lblerr.Text = "Unable to Veiw an Invoice";
            TekTravelCore.Audit.Add(TekTravelCore.EventType.MobileRecharge, TekTravelCore.Severity.Low, Convert.ToInt32(Session["memberId"]), "PendingMobileRecharge:View Refund Recharge error occured: " + ex.Message + ex.StackTrace, "0");
        }

    }

    /// <summary>
    /// Set Fileters For Search
    /// </summary>
    private void setFilters()
    {
        if (!String.IsNullOrEmpty(Request["FromDate"]) && !Request["FromDate"].Equals("DD/MM/YYYY"))
        {
            DateTime temDate = DateTime.ParseExact(Request["FromDate"], "dd/MM/yyyy", null);
            startDate = new DateTime(temDate.Year, temDate.Month, temDate.Day, 0, 0, 0).ToUniversalTime();
        }
        if (!String.IsNullOrEmpty(Request["ToDate"]) && !Request["ToDate"].Equals("DD/MM/YYYY"))
        {
            DateTime temDate = DateTime.ParseExact(Request["ToDate"], "dd/MM/yyyy", null);
            endDate = new DateTime(temDate.Year, temDate.Month, temDate.Day, 23, 59, 59).ToUniversalTime();
        }
        if (!string.IsNullOrEmpty(Request["AgentName"]))
        {
            agencyId = Convert.ToInt32(Request["AgentName"].Replace("'", "''").Trim());
        }
        if (txtTransID.Text.Trim() != "")
        {
            TranscationID = txtTransID.Text.Trim();
        }
    }
    /// <summary>
    /// Check Authorization 
    /// </summary>
    private void AuthorizationCheck()
    {
        if (Session["roleId"] == null)
        {
            String values = "?errMessage=Login Required to access " + Page.Title + " page.";
            values += "&requestUri=" + Request.Url.ToString();
            Response.Redirect("Default.aspx" + values, true);
        }
        else if (!(Role.IsAllowedTask((int)Session["roleId"], (int)Task.ViewPendingMobileRecharge)) || (Convert.ToInt32(Session["agencyId"]) != 0))
        {
            String values = "?errMessage=You are not authorised to access " + Page.Title + " page.";
            values += "&requestUri=" + Request.Url.ToString() + "&turnBack=no";
            Response.Redirect("Default.aspx" + values, true);
        }

    }
}
