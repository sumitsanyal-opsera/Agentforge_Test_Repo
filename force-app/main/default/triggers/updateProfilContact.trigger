trigger updateProfilContact on Account (after insert, after update) {
    updateProfilContactHandler.handleAccountUpdate(trigger.new);
}