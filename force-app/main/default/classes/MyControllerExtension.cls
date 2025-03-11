public with sharing class MyControllerExtension {
    private ApexPages.StandardSetController setController;

    public MyControllerExtension(ApexPages.StandardSetController setController) {
        this.setController = setController;
        
        Account [] records = [SELECT Id, Name FROM Account LIMIT 30];
        setController.setSelected(records);
    }
}