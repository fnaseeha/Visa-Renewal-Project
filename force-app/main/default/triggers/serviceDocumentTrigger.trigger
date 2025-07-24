/**
 * @description       : Updates the Next Renewal Date during insert and update operations.
 * @author            : Naseeha
 * @last modified on  : 07-20-2025
**/
trigger serviceDocumentTrigger on Service_Document__c (before insert,before update) {

    serviceDocumentTriggerHandler.updateServiceDocument(Trigger.new);

}