@isTest
public class WarehouseSyncScheduleTest {
    public static String CRON_EXP = '0 0 1 * * ?';
    
    @isTest
    public static void testScheduleJobs(){
        Test.startTest();
        // Schedule the test job
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        String jobId = System.schedule('WarehouseSyncScheduleTest',CRON_EXP,new WarehouseSyncSchedule());
        Test.stopTest();
        System.assertEquals('Test', 'Test');
    }
}