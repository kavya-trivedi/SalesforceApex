public with sharing class AccOppController {

    integer counter = 0;
    integer list_size = 20;
    public integer total_size;

    public List<Account> accounts { get; set; }

    public List<Opportunity> opportunities { get; set; }
    
    public String selectedAccountId { get; set; }
    
    public AccOppController() {
        total_size = [SELECT COUNT() FROM Account];
        getAccounts();
    }

    public Account[] getAccounts() {
        try {
            accounts = [SELECT Id, Name FROM Account ORDER BY Name LIMIT :list_size OFFSET :counter];
            return accounts;
        } catch (QueryException e) {
            ApexPages.addMessages(e);
            return null;
        }
    }

    public PageReference Beginning() {
        counter = 0;
        getAccounts();
        return null;
    }
    
    public PageReference Previous() {
        counter -= list_size;
        getAccounts();
        return null;
    }
    
    public PageReference Next() {
        counter += list_size;
        getAccounts();
        return null;
    }
    
    public PageReference End() {
        counter = total_size - math.mod(total_size, list_size);
        getAccounts();
        return null;
    }

    public Boolean getDisablePrevious() {
        if (counter > 0) return false;
        else return true;
    }

    public Boolean getDisableNext() {
        if(counter + list_size < total_size) return false;
        else return true;
    }

    // public Integer getTotal_size() {
    //     return total_size;
    // }

    // public Integer getPageNumber() {
    //     return counter/list_size + 1;
    // }

    // public Integer getTotalPages() {
    //     if (math.mod(total_size, list_size) > 0) {
    //         return total_size/list_size + 1;
    //     } else {
    //         return (total_size/list_size);
    //     }
    // }
    
    public PageReference handleAccountClick() {
        System.debug('Account clicked: ' + selectedAccountId);
        opportunities = [SELECT Name FROM Opportunity WHERE AccountId=:selectedAccountId];
        System.debug('Opportunities: ' + opportunities);
        return Page.OpportunityPagination;
    }
}