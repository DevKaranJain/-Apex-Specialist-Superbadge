public with sharing class MaintenanceRequestHelper {
    public static void updateWorkOrders(List<Case> caseList) {
        List<case> newCases = new List<Case>();
        Map<String,Integer> result=getDueDate(caseList);
        list<Equipment_Maintenance_Item__c> itemsListToinsert= new list<Equipment_Maintenance_Item__c>();
      Map<String,list<Equipment_Maintenance_Item__c>> resultItmes=getMaintainanceItems(caseList);
        for(Case c : caseList){
            if(c.status=='closed')
                if(c.type=='Repair' || c.type=='Routine Maintenance'){
                    Case newCase = new Case();
                    newCase.Status='New';
                    newCase.Origin='web';
                    newCase.Type='Routine Maintenance';
                    newCase.Subject='Routine Maintenance of Vehicle';
                    newCase.Vehicle__c=c.Vehicle__c;
                    newCase.Equipment__c=c.Equipment__c;
                    newCase.Date_Reported__c=Date.today();
                    newcase.Cloned_Case_Id__c=c.Id;
                    if(result.get(c.Id)!=null)
                     newCase.Date_Due__c=Date.today()+result.get(c.Id);
                    else
                        newCase.Date_Due__c=Date.today();
                    newCases.add(newCase);
                }
        }        
       if(newCases.size()>0)
       {  	
           insert newCases; 
           
           for(Case c : newCases){
             List<Equipment_Maintenance_Item__c> temp =  resultItmes.get(c.Cloned_Case_Id__c);
               if(temp !=null){
                    for(Equipment_Maintenance_Item__c row:temp){
                    Equipment_Maintenance_Item__c newitem = new Equipment_Maintenance_Item__c();
                        newitem.Equipment__c=row.Equipment__c;
                        newitem.Maintenance_Request__c= c.Id;
                        newitem.Quantity__c= row.Quantity__c;  
                        itemsListToinsert.add(newitem);
                        
                    }
               }
               
           }
           
           
       }
        
       if(itemsListToinsert.size()>0)
           insert itemsListToinsert;
    }
    //
    public static  Map<String,Integer> getDueDate(List<case> CaseIDs){       
       Map<String,Integer> result = new Map<String,Integer>();
        Map<Id, case> caseKeys = new Map<Id, case> (CaseIDs);        
       List<AggregateResult> wpc=[select Maintenance_Request__r.ID cID,min(Equipment__r.Maintenance_Cycle__c)cycle
                      from Equipment_Maintenance_Item__c where  Maintenance_Request__r.ID in :caseKeys.keySet() and Equipment__r.Maintenance_Cycle__c != null group by             Maintenance_Request__r.ID ];
        for(AggregateResult res :wpc){
            Integer addDays=0;
            if(res.get('cycle')!=null)
                addDays+=Integer.valueOf(res.get('cycle'));
            result.put((String)res.get('cID'),addDays);
        }
        return result;
}
    
    
     public static Map<String,list<Equipment_Maintenance_Item__c>> getMaintainanceItems(List<case> CaseIDs){       
     
       Map<String,list<Equipment_Maintenance_Item__c>> mapofMaintainanceItems = new Map<String,list<Equipment_Maintenance_Item__c>>();
        Map<Id, case> caseKeys = new Map<Id, case> (CaseIDs);        
       list<Equipment_Maintenance_Item__c> lstrec = new  list<Equipment_Maintenance_Item__c>([select id ,Maintenance_Request__c,Equipment__c,Quantity__c  
                      from Equipment_Maintenance_Item__c where  Maintenance_Request__r.ID in :caseKeys.keySet() ]);
        
         for(Equipment_Maintenance_Item__c row:lstrec){
              
                if (mapofMaintainanceItems.containsKey(row.Maintenance_Request__c)) {
                    List<Equipment_Maintenance_Item__c> temp = mapofMaintainanceItems.get(row.Maintenance_Request__c);
						temp.add(row);
					mapofMaintainanceItems.put(row.Maintenance_Request__c, temp);
                }
				else{
                    mapofMaintainanceItems.put(row.Maintenance_Request__c, new List<Equipment_Maintenance_Item__c> { row });
                }    
               		
         }
         
        return mapofMaintainanceItems;
}
    
    
}