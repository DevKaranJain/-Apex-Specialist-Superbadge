/*trigger MaintenanceRequest on Case (before update, after update) {
     Map<Id,Case> caseLst = new Map<Id,Case>(); 
    if(Trigger.isUpdate  && Trigger.isAfter){
        for(Case oCase: Trigger.new){
            if (oCase.IsClosed && (oCase.Type.equals('Repair') || oCase.Type.equals('Routine Maintenance'))){
                caseLst.put(oCase.Id, oCase);
            }
        }
        if(caseLst.size() > 0){
            
        	MaintenanceRequestHelper.updateWorkOrders(caseLst);    
        }        
    }
}*/

trigger MaintenanceRequest on Case (before update, after update) {
     if(Trigger.isAfter) 
     {
         MaintenanceRequestHelper.updateWorkOrders(Trigger.New);
      }
  }