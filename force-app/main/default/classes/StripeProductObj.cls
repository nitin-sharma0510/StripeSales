/**
 * @File Name          : StripeProductObj.cls
 * @Description        : 
 * @Author             : Sumit Singh | sumit@teqfocus.com
 * @Group              : 
 * @Last Modified By   : Sumit Singh | sumit@teqfocus.com
 * @Last Modified On   : 10/18/2019, 7:22:53 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/18/2019   Sumit Singh | sumit@teqfocus.com     Initial Version
**/
public with sharing class StripeProductObj {

    public String id {get;set;}
    public Boolean active {get;set;}
    public String name {get;set;}
    public String[] attributes {get;set;}
    public DateTime created {get;set;}
    public String description {get;set;}
    public DateTime updated {get;set;}   

    public StripeProductObj() {

    }
}