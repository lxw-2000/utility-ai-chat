@SuppressWarnings('PMD.ApexSuggestUsingNamedCred')
public without sharing class ChatController {

    public static final Integer MAX_TIMEOUT = 120000;
    public static final String POST = 'POST';
    public static final String DEEPSEEK_API_CHAT_COMPLETIONS= 'callout:DeepSeek_API/chat/completions';
    public static final String DEEPSEEK_BEARER = '{!$Credential.Deepseek_Credentials.Bearer}';

    @AuraEnabled
    public static String deepseekChat(String chatMessages){
        try {
            Map<String, Object> requestBody = new Map<String, Object>();
            List<Map<String, String>> messages = (List<Map<String, String>>) JSON.deserialize(chatMessages, List<Map<String, String>>.class);
            requestBody.put('model', 'deepseek-chat');
            requestBody.put('messages', messages);
            requestBody.put('stream', false);
            HttpResponse res = callout(requestBody, DEEPSEEK_API_CHAT_COMPLETIONS, 'Bearer ' + DEEPSEEK_BEARER);
            return res.getBody(); 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static HttpResponse callout(Map<String, Object> requestBody, String endpoint, String key) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod(POST);
        req.setHeader('Authorization', key); 
        req.setTimeout(MAX_TIMEOUT);
        req.setBody(JSON.serialize(requestBody));
        HttpResponse res = new Http().send(req);
        return res;
    }
}