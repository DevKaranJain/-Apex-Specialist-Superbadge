public with sharing class WarehouseCalloutService implements Queueable {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    @future(callout=true)
    public static void runWarehouseEquipmentSync(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment?_ga=2.28802172.1514656825.1675057363-162724268.1671968463');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
            system.debug(response.getBody());
            String str  = response.getBody();
            System.debug('String - ' + str);  
            
            
            List<Product2> prList = new List<Product2>();
           List<object> results = (List<object>) JSON.deserializeUntyped(String.valueOf(str));
            for(Object obj : results){
                Map<String , Object > sObjMap = (Map<String,Object>)obj;
                prList.add(new Product2(  Name =(String) sObjMap.get('name') , Replacement_Part__c = True , Warehouse_SKU__c =(String) sObjMap.get('sku')  , Cost__c =(Decimal) sObjMap.get('cost') , Current_Inventory__c =(Integer) sObjMap.get('quantity'), Lifespan_Months__c = (Integer)sObjMap.get('lifespan'), Maintenance_Cycle__c  = (Integer)sObjMap.get('maintenanceperiod') , productCode =(String)sobjMap.get('_id')));
            }

            if(prlist.size() > 0 ){
                upsert prList Warehouse_SKU__c;
            }
            
        }
    }
    public static void execute(QueueableContext context){
       runWarehouseEquipmentSync();
   }
    
}