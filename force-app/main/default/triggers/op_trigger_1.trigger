public class OpportunityValidationHandler {
    public static void validateAmount(List<Opportunity> opportunities) {
        for(Opportunity opp : opportunities) {
            if(opp.Amount < 5000) {
                opp.addError('Amount cannot be less than 5000');
            }
        }
    }
}