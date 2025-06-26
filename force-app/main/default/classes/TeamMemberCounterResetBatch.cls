public with sharing class TeamMemberCounterResetBatch implements Database.Batchable<SObject>, Schedulable{

    public String query = 'SELECT Id, prospects_count__c FROM Team_Member__c';
    private static final String BATCH_NAME = 'Montlhy Team Member Prospect Count Reset';

    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }

    public void execute(SchedulableContext sc) {
        Database.executeBatch(new TeamMemberCounterResetBatch());
    }

    public void execute(Database.BatchableContext bc, List<SObject> scope){

        TeamMemberCounterResetBatchService service = new TeamMemberCounterResetBatchService();

        service.resetCounters(scope);
    }

    public void finish(Database.BatchableContext bc){
        return;
    }

    public static void scheduleBatch(){
        String schedule = '0 0 0 1 * ?';

		System.schedule(BATCH_NAME, schedule, new TeamMemberCounterResetBatch());
    }
}