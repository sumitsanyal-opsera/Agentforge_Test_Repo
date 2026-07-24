trigger AccountToContactUpdate on Account (after insert) {
    List<Contact> contactsToInsert = new List<Contact>();

    for (Account acc : Trigger.new) {
        Contact con = new Contact();
        con.LastName = 'Test Contact-' + acc.Name;
        con.AccountId = acc.Id;
        contactsToInsert.add(con);
    }

    if (contactsToInsert.size() > 0) {
        if (Schema.sObjectType.Contact.isCreateable()) {
            insert contactsToInsert;
        }
    }
}