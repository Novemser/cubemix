package com.fudan.cubemix.listener;

import com.fudan.cubemix.controller.MainController;
import com.fudan.cubemix.service.SocketService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

/**
 * @package com.fudan.cubemix.listener
 * @Author Novemser
 * @Date 2017/11/4
 * <p>
 * Crafting with devotion.
 */
@Component
public class StartupListener {

    private final SocketService socketService;

    private final MainController mainController;

    @Autowired
    public StartupListener(SocketService socketService, MainController mainController) {
        this.socketService = socketService;
        this.mainController = mainController;
    }

    @EventListener(ContextRefreshedEvent.class)
    public void startUp() {
        new Thread(socketService::initService).start();
    }
}
