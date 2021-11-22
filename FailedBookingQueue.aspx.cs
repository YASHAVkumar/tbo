using System;
using System.Collections.Generic;
using System.Web.UI;
using TekTravel.BookingEngine;
using TekTravel.Core;
using TekTravel.Configuration;

public partial class FailedBookingQueue : System.Web.UI.Page
{
    protected int recordsPerPage = Convert.ToInt32(ConfigurationSystem.PagingConfig["FailedBookingQueueRecordsPerPage"]);
    protected int noOfPages;
    protected int pageNo;
    protected int AdminId = 1;
    protected List<FailedBooking> fblist;
    protected string show = string.Empty;
    protected int rowCount;
    protected int lower;
    protected int upper;
    protected int j = 0;
    protected string errorMessage = string.Empty;
    protected string searchQueryString = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        AuthorizationCheck();

        //foreach (Status val in Enum.GetValues(typeof(Status)))
        //{
            
        //}
        Page.Title = "Failed Booking Queue";
        if (Request["pageno"] != null)
        {
            pageNo = Convert.ToInt32(Request["pageno"]);
        }
        else
        {
            pageNo = 1;
        }
        lower = (pageNo * recordsPerPage) - (recordsPerPage - 1);
        upper = pageNo * recordsPerPage;
        if (Convert.ToInt32(Session["agencyId"]) == 0)
        {
            if (!string.IsNullOrEmpty(Request["inputPNRsearch"]) || !string.IsNullOrEmpty(Request["inputAgencyName"]) || !string.IsNullOrEmpty(Request["inputAirline"]) || !string.IsNullOrEmpty(Request["inputPaxName"]) || !string.IsNullOrEmpty(Request["bStatus"]) || !string.IsNullOrEmpty(Request["bMode"]) || !string.IsNullOrEmpty(Request["inputTxnId"]))
            {
                fblist = FailedBooking.GetAllFailedBookingFilter(Request["inputPNRsearch"].Trim(), Request["inputAgencyName"].Trim(), Request["inputAirline"].Trim(), Request["inputPaxName"].Trim(), lower, upper, Request["bStatus"], Request["bMode"], Request["inputTxnId"].Trim());
                if (fblist != null && fblist.Count != 0)
                    rowCount = fblist[0].TotalCount;
                searchQueryString = "&inputPNRsearch=" + Request["inputPNRsearch"].Trim() + "&inputAgencyName=" + Request["inputAgencyName"].Trim() + "&inputAirline=" + Request["inputAirline"].Trim() + "&inputPaxName=" + Request["inputPaxName"].Trim() + "&bStatus=" + Request["bStatus"].Trim() + "&bMode=" + Request["bMode"].Trim() + "&inputTxnId=" + Request["inputTxnId"].Trim();
            }
            else
            {
                fblist = FailedBooking.GetAllFailedBooking(lower, upper);
                rowCount = FailedBooking.GetCount();
            }
        }
        else
        {
            if (!string.IsNullOrEmpty(Request["inputPNRsearch"]) || !string.IsNullOrEmpty(Request["inputAirline"]) || !string.IsNullOrEmpty(Request["inputPaxName"]) || !string.IsNullOrEmpty(Request["bStatus"]) || !string.IsNullOrEmpty(Request["inputTxnId"]))
            {
                fblist = FailedBooking.GetAllFailedBookingFilter(Request["inputPNRsearch"].Trim(), new Agency(Convert.ToInt32(Session["agencyId"])).AgencyName.Trim(), Request["inputAirline"].Trim(), Request["inputPaxName"].Trim(), lower, upper, Request["bStatus"], Request["bMode"], Request["inputTxnId"].Trim());
                if (fblist != null && fblist.Count != 0)
                    rowCount = fblist[0].TotalCount;
                searchQueryString = "&inputPNRsearch=" + Request["inputPNRsearch"].Trim() + "&inputAgencyName=" + new Agency(Convert.ToInt32(Session["agencyId"])).AgencyName.Trim() + "&inputAirline=" + Request["inputAirline"].Trim() + "&inputPaxName=" + Request["inputPaxName"].Trim() + "&bStatus=" + Request["bStatus"].Trim() + "&bMode=" + Request["bMode"].Trim() + "&inputTxnId=" + Request["inputTxnId"].Trim();
            }
            else
            {
                fblist = FailedBooking.GetAllFailedBooking(Convert.ToInt32(Session["agencyId"]), lower, upper);
                rowCount = FailedBooking.GetCount(Convert.ToInt32(Session["agencyId"]));
            }
        }
        string url = "FailedBookingQueue.aspx?" + searchQueryString;
        if ((rowCount % recordsPerPage) != 0)
        {
            noOfPages = (rowCount / recordsPerPage) + 1;
        }
        else
        {
            noOfPages = (rowCount / recordsPerPage);
        }
        if (noOfPages > 0)
        {
            show = Utility.Paging(noOfPages, url, pageNo);
        }
    }

    private void AuthorizationCheck()
    {
        if (Session["roleId"] == null)
        {
            String values = "?errMessage=Login Required to access " + Page.Title + " page.";
            values += "&requestUri=" + Request.Url.ToString();
            Response.Redirect("Default.aspx" + values, true);
        }
        else if (!(Role.IsAllowedTask((int)Session["roleId"], (int)Task.ViewFailedBookingQueue) || Convert.ToInt32(Session["agencyId"]) > 0))
        {
            String values = "?errMessage=You are not authorised to access " + Page.Title + " page.";
            values += "&requestUri=" + Request.Url.ToString() + "&turnBack=no";
            Response.Redirect("Default.aspx" + values, true);
        }

    }
}
