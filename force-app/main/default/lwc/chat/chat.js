import { LightningElement } from 'lwc';
import deepseekChat from '@salesforce/apex/ChatController.deepseekChat'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Chat extends LightningElement {
    messages = []; // 聊天记录
    newMessage = ''; // 用户输入
    isLoading = false; // 加载状态
    error; // 错误信息

    // 处理输入变化
    handleInputChange(event) {
        this.newMessage = event.target.value;
    }

    // 发送消息
    async handleSend() {
        if (!this.newMessage.trim()) return;
        
        try {
            this.isLoading = true;
            
            // 添加用户消息（保持不变）
            this.messages = [...this.messages, {
                id: Date.now(),
                content: this.newMessage,
                isUser: true,
                timestamp: new Date().toISOString()
            }];

            // 替换为Apex调用
            const aiResponse = await deepseekChat({ 
                message: this.newMessage 
            });

            // 添加AI回复（根据实际响应结构调整）
            this.messages = [...this.messages, {
                id: Date.now(),
                content: aiResponse,
                isUser: false,
                timestamp: new Date().toISOString()
            }];

        } catch (error) {
            this.dispatchEvent(new ShowToastEvent({
                title: '请求失败',
                message: error.body?.message || error.message,
                variant: 'error'
            }));
        } finally {
            this.isLoading = false;
            this.newMessage = '';
        }
    }
}