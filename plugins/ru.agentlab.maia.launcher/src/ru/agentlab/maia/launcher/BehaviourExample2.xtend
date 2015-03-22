package ru.agentlab.maia.launcher

import javax.inject.Inject
import javax.inject.Named
import org.slf4j.LoggerFactory
import ru.agentlab.maia.Action
import ru.agentlab.maia.ActionTicker
import ru.agentlab.maia.behaviour.IBehaviour

class BehaviourExample2 {

	val static LOGGER = LoggerFactory.getLogger(BehaviourExample2)

	@Inject
	@Named(IBehaviour.KEY_NAME)
	String behName

	@Action(type=IBehaviour.TYPE_TICKER)
	@ActionTicker(period=600, fixedPeriod=false)
	def void action() {
		LOGGER.info("Behaviour [{}] timestamp [{}]", behName, System.currentTimeMillis)
	}

}