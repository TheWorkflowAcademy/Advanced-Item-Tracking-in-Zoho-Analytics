SELECT
/* This report aggregates all the Invoice, Package items, Bill items, purchase received items, vendor and credit note items, and transfer 
and inventory adjustment line items. Using these 8 reports, all aggregated into one, you can then create separate Summary Reports for each 
type of transaction, put them all in one dashboard, and filter them all using only ONE user filter.  */
		 ia."Order Number" AS "Transaction #",
		 w."Warehouse Name" AS "Source : Destination Warehouse",
		 u."UserName" as 'Salesperson/Created By',
		 '' as 'Vendor',
		 '' as 'Customer',
		 ia."Reason" AS 'Status/Reason',
		 a."Quantity Adjusted" AS 'Quantity',
		 i."Item Name" as 'Item Name',
		 i."SKU" AS 'SKU',
		 a."Created Time" AS 'Date Created',
		 concat('https://inventory.zoho.com/app#/inventory/adjustments/', ia."Inventory Adjustment ID") as 'Original Record',
		 '' as 'Sales Order #',
		 '' as 'Sales Order',
     /* The Sales order columns are optional. Some companies may want them. They can easily be excluded in the summary tables though. */
		 'Inventory Adjustment' as 'Type'
     /* This column is separate for each of the 8 reports and allows for easy filtering */
FROM  "Inventory Adjustment Items" a
JOIN "Inventory Adjustments" ia ON a."Inventory Adjustment ID"  = ia."Inventory Adjustment ID" 
LEFT JOIN "Warehouses" w ON a."Warehouse ID"  = w."Warehouse ID" 
LEFT JOIN "Items" i ON i."Item ID"  = a."Product ID" 
LEFT JOIN "Users" u ON u."User ID"  = ia."Created By"  
UNION ALL
SELECT
/* The initial order of the columns does not matter so much. You may decide how they appear in the Summary table. But, subsequent SELECT commands in
this report need to have the same order of columns as the first one */
		 II."Invoice Number" AS 'Transaction #',
		 III."Warehouse Name" AS "Source : Destination Warehouse",
		 IIII."UserName" AS 'Salesperson/Created By',
		 '' as 'Vendor',
		 c."Customer Name" as 'Customer',
		 II."Status" AS 'Status/Reason',
		 I."Quantity" AS 'Quantity',
		 I."Item Name" AS 'Item Name',
		 IIIII."SKU" AS 'SKU',
		 I."Created Time" AS 'Date Created',
		 concat('https://books.zoho.com/app#/invoices/', I."Invoice ID") as 'Original Record',
		 s."Sales Order#" as 'Sales Order #',
		 concat('https://books.zoho.com/app#/salesorders/', so."Sales order ID") as 'Sales Order',
		 'Invoice Item' as 'Type'
FROM  "Invoice Items" I
/* The LEFT JOIN ensures that every row in the parent table appears even if there is no match on the 'right side'. This produces somewhat useless, empty data,
but at least we can see which records need to be completed. */
JOIN "Invoices" II ON II."Invoice ID"  = I."Invoice ID" 
LEFT JOIN "Warehouses" III ON III."Warehouse ID"  = I."Warehouse ID" 
LEFT JOIN "Users" IIII ON II."Salesperson"  = IIII."User ID" 
LEFT JOIN "Items" IIIII ON IIIII."Item ID"  = I."Product ID" 
LEFT JOIN "Customers" c ON c."Customer ID"  = II."Customer ID" 
LEFT JOIN "Sales Order Items" so ON so."Item ID"  = I."SO ItemID" 
LEFT JOIN "Sales Orders" s ON s."Sales order ID"  = so."Sales order ID"  
UNION ALL
 SELECT
		 II."Packing Number" as 'Transaction #',
		 IIII."Warehouse Name" AS "Source : Destination Warehouse",
		 u."UserName" as 'Salesperson/Created By',
		 '' as 'Vendor',
		 c."Customer Name" as 'Customer',
		 V."Status" AS 'Status/Reason',
		 I."Quantity Packed" AS 'Quantity',
		 I."Item Name" AS 'Item Name',
		 VI."SKU" AS 'SKU',
		 II."Packing Date" AS 'Date Created',
		 concat('https://books.zoho.com/app#/packages/', I."Package ID") as 'Original Record',
		 so."Sales Order#" as 'Sales Order #',
		 concat('https://books.zoho.com/app#/salesorders/', s."Sales order ID") as 'Sales Order',
		 'Package Item' as 'Type'
FROM  "Package Items" I
LEFT JOIN "Packages" II ON I."Package ID"  = II."Package ID" 
LEFT JOIN "Sales Order Items" s ON s."Item ID"  = I."SO ItemID" 
LEFT JOIN "Sales Orders" so ON so."Sales order ID"  = s."Sales order ID" 
LEFT JOIN "Warehouses" IIII ON IIII."Warehouse ID"  = s."Warehouse ID" 
LEFT JOIN "Shipment Order" V ON V."Shipment ID"  = II."Shipment ID" 
LEFT JOIN "Items" VI ON VI."Item ID"  = I."Product ID" 
LEFT JOIN "Customers" c ON c."Customer ID"  = so."Customer ID" 
LEFT JOIN "Users" u ON u."User ID"  = so."Salesperson"  
UNION ALL
 SELECT
		 po."Reference number" AS 'Transaction #',
		 III."Warehouse Name" AS "Source : Destination Warehouse",
		 u."UserName" as 'Salesperson/Created By',
		 v."Vendor Name" as 'Vendor',
		 '' as 'Customer',
		 'Received' as 'Status/Reason',
		 I."Quantity Received" AS "Quantity",
		 II."Item Name" AS "Item Name",
		 IIII."SKU" AS "SKU",
		 I."Created Time" AS 'Date Created',
		 concat('https://books.zoho.com/app#/purchaseorders/', II."Purchase Order ID") as 'Original Record',
		 '' as 'Sales Order #',
		 '' as 'Sales Order',
		 'Purchase Received Item' as 'Type'
FROM  "Purchase Receive Items" I
LEFT JOIN "Purchase Order Items" II ON I."Purchase Order Item ID"  = II."Item ID" 
LEFT JOIN "Warehouses" III ON III."Warehouse ID"  = II."Warehouse ID" 
LEFT JOIN "Items" IIII ON II."Product ID"  = IIII."Item ID" 
LEFT JOIN "Purchase Orders" po ON po."Purchase Order ID"  = II."Purchase Order ID" 
LEFT JOIN "Users" u ON u."User ID"  = po."Created By" 
LEFT JOIN "Vendors" v ON v."Vendor ID"  = po."Vendor ID"  
UNION ALL
 SELECT
		 II."Bill Number" AS 'Transaction #',
		 III."Warehouse Name" AS "Source : Destination Warehouse",
		 u."UserName" as 'Salesperson/Created By',
		 v."Vendor Name" as 'Vendor',
		 '' as 'Customer',
		 II."Bill Status" as 'Status/Reason',
		 I."Quantity" AS "Quantity",
		 I."Item Name" AS "Item Name",
		 IIIII."SKU" AS "SKU",
		 II."Bill Date" AS 'Date Created',
		 concat('https://books.zoho.com/app#/bills/', I."Bill ID") as 'Original Record',
		 '' as 'Sales Order #',
		 '' as 'Sales Order',
		 'Bill Item' as 'Type'
FROM  "Bill Item" I
LEFT JOIN "Bills" II ON II."Bill ID"  = I."Bill ID" 
LEFT JOIN "Warehouses" III ON III."Warehouse ID"  = I."Warehouse ID" 
LEFT JOIN "Vendors" v ON II."Vendor ID"  = v."Vendor ID" 
LEFT JOIN "Items" IIIII ON IIIII."Item ID"  = I."Product ID" 
LEFT JOIN "Users" u ON u."User ID"  = II."Created By"  
UNION ALL
 SELECT
		 c."Credit Note Number" as 'Transaction #',
		 w."Warehouse Name" AS "Source : Destination Warehouse",
		 u."UserName" as 'Salesperson/Created By',
		 '' as 'Vendor',
		 cus."Customer Name" as 'Customer',
		 c."Credit Note Status" as 'Status/Reason',
		 cn."Quantity" AS "Quantity",
		 i."Item Name" AS "Item Name",
		 i."SKU" AS "SKU",
		 c."Created Time" AS 'Date Created',
		 concat('https://books.zoho.com/app#/creditnotes/', cn."CreditNotes ID") as 'Original Record',
		 '' as 'Sales Order #',
		 '' as 'Sales Order',
		 'Credit Note Item' as 'Type'
FROM  "Credit Note Items" cn
JOIN "Credit Notes" c ON c."CreditNotes ID"  = cn."CreditNotes ID" 
LEFT JOIN "Warehouses" w ON w."Warehouse ID"  = cn."Warehouse ID" 
LEFT JOIN "Items" i ON i."Item ID"  = cn."Product ID" 
LEFT JOIN "Users" u ON u."User ID"  = c."Created By" 
LEFT JOIN "Customers" cus ON cus."Customer ID"  = c."Customer ID"  
UNION ALL
 SELECT
		 v."Vendor Credit Number" as 'Transaction #',
		 w."Warehouse Name" AS "Source : Destination Warehouse",
		 u."UserName" as 'Salesperson/Created By',
		 ven."Vendor Name" as 'Vendor',
		 '' as 'Customer',
		 v."Vendor Credit Status" as 'Status/Reason',
		 vci."Quantity" AS "Quantity",
		 i."Item Name" AS "Item Name",
		 i."SKU" AS "SKU",
		 v."Created Time" AS 'Date Created',
		 concat('https://books.zoho.com/app#/vendorcredits/', v."Vendor Credit ID") as 'Original Record',
		 '' as 'Sales Order #',
		 '' as 'Sales Order',
		 'Vendor Credit Item' as 'Type'
FROM  "Vendor Credit Items" vci
JOIN "Vendor Credits" v ON v."Vendor Credit ID"  = vci."Vendor Credit ID" 
LEFT JOIN "Warehouses" w ON w."Warehouse ID"  = vci."Warehouse ID" 
LEFT JOIN "Items" i ON i."Item ID"  = vci."Product ID" 
LEFT JOIN "Users" u ON u."User ID"  = v."Created By" 
LEFT JOIN "Vendors" ven ON ven."Vendor ID"  = v."Vendor ID"  
UNION ALL
 SELECT
		 o."Order Number" as 'Transaction #',
     /* We concatenate two SELECT commands into one column in order to see bouth the source and destination warehouse for the transaction. */
		 concat(w."Warehouse Name", ' : ', ware."Warehouse Name") AS "Source : Destination Warehouse",
		 u."UserName" as 'Salesperson/Created By',
		 '' as 'Vendor',
		 '' as 'Customer',
		 o."Status" as 'Status/Reason',
		 t."Transferred Quantity" AS "Quantity",
		 i."Item Name" AS "Item Name",
		 i."SKU" AS "SKU",
		 t."Created Time" AS 'Date Created',
		 concat('https://books.zoho.com/app#/inventory/transferorders/', o."Transfer Order ID") as 'Original Record',
		 '' as 'Sales Order #',
		 '' as 'Sales Order',
		 'Transfer Order Item' as 'Type'
FROM  "Transfer Order Items" t
LEFT JOIN "Transfer Order" o ON o."Transfer Order ID"  = t."Transfer Order ID" 
/* We join the Warehouses table to this report twice because we need both the source and destination warehouse */
LEFT JOIN "Warehouses" w ON w."Warehouse ID"  = o."Destination Warehouse" 
LEFT JOIN "Warehouses" ware ON ware."Warehouse ID"  = o."Source Warehouse" 
LEFT JOIN "Items" i ON i."Item ID"  = t."Product ID" 
LEFT JOIN "Users" u ON u."User ID"  = o."Created By"  
