public with sharing class SearchController {
    @AuraEnabled(cacheable=true)
    public static Map<String, List<SObject>> searchRecords(String searchKeyword, List<String> objectNames) {
        if (String.isEmpty(searchKeyword) || objectNames.isEmpty()) {
            return new Map<String, List<SObject>>();
        }

        Map<String, List<SObject>> resultMap = new Map<String, List<SObject>>();

        String objectList = '';
        for (String obj : objectNames) {
            objectList += obj + '(Id, Name), ';
        }

        // Removing the last comma and space
        objectList = objectList.substring(0, objectList.length() - 2);

        String soslQuery = 'FIND \'' + searchKeyword + '\' IN ALL FIELDS RETURNING ' + objectList;
        
        try {
            List<List<SObject>> searchResults = search.query(soslQuery);

            Integer index = 0;
            for (String obj : objectNames) {
                if (index < searchResults.size()) {
                    resultMap.put(obj, searchResults[index]);
                }
                index++;
            }
        } catch (Exception e) {
            System.debug('Error executing SOSL: ' + e.getMessage());
        }

        return resultMap;
    }
}


// String a = 'kavya';
// List<String> l = new List<String>();
// l.add('Account');
// SearchController.searchRecords(a, l);