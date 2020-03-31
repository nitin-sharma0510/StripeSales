/**
 * @File Name          : StripeCardObj.cls
 * @Description        : 
 * @Author             : Sumit Singh | sumit@teqfocus.com
 * @Group              : 
 * @Last Modified By   : Sumit Singh | sumit@teqfocus.com
 * @Last Modified On   : 10/22/2019, 4:06:56 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/22/2019   Sumit Singh | sumit@teqfocus.com     Initial Version
**/
public class StripeCardObj 
{
    public String brand {get;set;}
    public String country {get;set;}
    public Integer last4 {get;set;}
    public Integer exp_month {get;set;}
    public Integer exp_year {get;set;}
    public String fingerprint {get;set;}

    public StripeCardObj() {}
}