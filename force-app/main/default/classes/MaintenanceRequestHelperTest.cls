@isTest
public with sharing class MaintenanceRequestHelperTest {
    @isTest
    public static void testClosedMRs(){
        
        Vehicle__c vel = new Vehicle__c();
        vel.Name = 'Test Vehicle 1';
        vel.Bathrooms__c = 1;
        vel.Bedrooms__c = 1;
        vel.Model__c = 'Test Model 1';
        vel.Air_Conditioner__c = true;
        insert vel;
        
        Case cs = new Case();
        cs.Vehicle__c = vel.id;
        cs.Date_Reported__c = Date.today();
        cs.Type = 'Routine Maintenance';
        cs.Subject = 'New Case Created as ' + 0000 + ' Closed!!';
        cs.Priority = 'Medium';
        cs.Status = 'New';
        insert cs;
        
        Case cs1 = new Case();
        cs1.Vehicle__c = vel.id;
        cs1.Date_Reported__c = Date.today();
        cs1.Type = 'Routine Maintenance';
        cs1.Subject = 'New Case Created as ' + 0022 + ' Closed!!';
        cs1.Priority = 'Medium';
        cs1.Status = 'New';
        insert cs1;
        
        Product2 equip = new Product2();
        equip.Name = 'Test Equipment 1';
        equip.Cost__c = 100;
        equip.Maintenance_Cycle__c = 120;
        equip.Replacement_Part__c = true;
        insert equip;
        
        Product2 equip1 = new Product2();
        equip1.Name = 'Test Equipment 2';
        equip1.Cost__c = 110;
        equip1.Maintenance_Cycle__c = 80;
        equip1.Replacement_Part__c = true;
        insert equip1;
        
        Equipment_Maintenance_Item__c emi = new Equipment_Maintenance_Item__c();
        emi.Maintenance_Request__c = cs.Id;
        emi.Equipment__c = equip.Id;
        insert emi;
        
        Equipment_Maintenance_Item__c emi1 = new Equipment_Maintenance_Item__c();
        emi1.Maintenance_Request__c = cs.Id;
        emi1.Equipment__c = equip.Id;
        insert emi1;
        
		Equipment_Maintenance_Item__c emi2 = new Equipment_Maintenance_Item__c();
        emi2.Maintenance_Request__c = cs.Id;
        emi2.Equipment__c = equip1.Id;
        insert emi2;
        
        cs.Status = 'Closed';
        cs1.Status = 'Closed';
        List<Case> updateCaseList = new List<Case>();
        
        updateCaseList.add(cs1);
        updateCaseList.add(cs);

        update updateCaseList;
		List<Case> csListCount = [SELECT Id FROM Case WHERE Vehicle__c = :vel.Id];
        System.assertEquals(4,csListCount.size());
        
    }
}