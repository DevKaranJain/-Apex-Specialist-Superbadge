global with sharing class WarehouseSyncSchedule implements Schedulable, Database.AllowsCallouts {
    global void execute( SchedulableContext context ){
	  	System.enqueueJob(new WarehouseCalloutService());
    }
}