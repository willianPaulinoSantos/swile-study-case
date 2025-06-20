@isTest
public with sharing class UserFixtureFactory {


    public static User create(User userToInsert){
        insert userToInsert;

        return userToInsert;
    }

    public static User create(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        User standardTestUser = new User(
                FirstName = 'Test',
                LastName = 'User',
                Alias = 'tuser',
                Email = 'testuser@example.com',
                Username = 'testuser_' + DateTime.now().getTime() + '@example.com',
                TimeZoneSidKey = 'Europe/Paris',
                LocaleSidKey = 'fr_FR',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'fr',
                ProfileId = p.Id
                );

        insert standardTestUser;

        return standardTestUser;
    }
}