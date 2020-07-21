# Advanced Item Tracking in Zoho Analytics
Using this query table, along with Zoho's summary reports built using it as a base table, you can track your item-level inventory through every possible transaction in one centralized dashboard in Zoho Analytics. You can build something similar without the 100+ lines of SQL code, but this report enables you to create a clean, user-friendly dashboard that only requires *one* User Filter instead of one for every single report - and there are 8.

## Setup
Follow the same proceducures that you would to build any other query table. Simply ensure the correct sync is in place between Analytics and the Zoho Financial Suite. For this table in particular, you will need the ID's of every type of transaction, the Product ID's, the Users table and info, Warehouses, Vendors, Customers, etc.

## Code Walkthrough
Each of the 8 reports is similar. They are all built on an "Items" table. Then, taking advantage of the various lookup columns, we join other tables to it to bring in other information, like the Salesperson, Warehouse, Status, Vendor, or Customer, etc.

So first, for no particular reason, we have the Inventory Adjustments Items table. From this we can pull the quantity adjusted and the date. To that we join the Inventory Adjustments table, which helps us bring in the Order Number and the Reason. We connect the Warehouses table next to join in the warehouse name, the Items table to get the Item namd and SKU, and last, the Users table so we can see who created the Inventory Adjustment. There are, of course, no vendors or customers associated with Inventory Adjustments, so those remain blank. 

The 'Original Record' column is a concatenation of the base URL of the record and its record ID, which we then turn into a URL that links to the original record in Zoho Books. After you build, save, and view the Query table, click on that column, click More > Change Data Type > URL. 

Now, follow a similar process for the next 7 reports. The order of the columns is not particularly important, but once you set it in the first SELECT command, the column order in subsequent SELECT commands must match. Likewise, table aliases and names are not really important. I have used a variety of naming methods here to demonstrate, but you may experiment. 

Some lines to note: 171, 188-89. Here we concatenate the names of both the **source** and **destination** warehouses into one field, because it is an Inventory Transfer. You need to join the Warehouses table twice, matching on the different Warehouse ID's each time. Also, the `Type` column is important because it allows us to easily filter the Summary reports.

## After the Query Table is Built
Now, you have a list of ALL transactions that affect inventory in any way and (if your business keeps its records clean) the Item Name, SKU, Date, etc. for each one! On top of this report, you can build Summary Reports, one for each kind of transaction. Filter them using the `Type` column. Then, throw all 8 of those summary reports into a Dashboard and you can then select User Filters that filter all 8 reports at once, because they come from the same base table.

Another neat feature is the ability to create custom links in Zoho Books. For example, you can create a dynamic link, attached to the items module, that opens up a view to this Analytics dashboard and pre-filters it by that item's SKU. Lots of possiblities here.
