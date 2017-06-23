package ru.agentlab.maia.fipa;

import static ru.agentlab.maia.fipa.FIPAPerformativeNames.AGREE;
import static ru.agentlab.maia.fipa.FIPAPerformativeNames.CANCEL;
import static ru.agentlab.maia.fipa.FIPAPerformativeNames.FAILURE;
import static ru.agentlab.maia.fipa.FIPAPerformativeNames.INFORM;
import static ru.agentlab.maia.fipa.FIPAPerformativeNames.NOT_UNDERSTOOD;
import static ru.agentlab.maia.fipa.FIPAPerformativeNames.REFUSE;
import static ru.agentlab.maia.fipa.FIPAPerformativeNames.REQUEST;
import static ru.agentlab.maia.fipa.FIPAProtocolNames.FIPA_REQUEST;

<<<<<<< HEAD
import javax.annotation.PreDestroy;

import org.semanticweb.owlapi.model.OWLIndividualAxiom;

import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;
=======
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.annotation.PreDestroy;
>>>>>>> e9ddd18f... Implement FIPA protocols

import ru.agentlab.maia.agent.IGoal;
import ru.agentlab.maia.agent.IMessage;
<<<<<<< HEAD
import ru.agentlab.maia.message.annotation.OnMessageReceived;
import ru.agentlab.maia.message.impl.AclMessage;

public class FIPARequestResponder extends AbstractResponder {

	private final BiMap<IMessage, OWLIndividualAxiom> goals = HashBiMap.create();

	@OnMessageReceived
	public void onMessage(AclMessage message) {
		if (notMyMessage(message)) {
=======
import ru.agentlab.maia.goal.IGoal;
import ru.agentlab.maia.message.annotation.OnMessageReceived;
import ru.agentlab.maia.message.impl.AclMessage;
import ru.agentlab.maia.time.annotation.OnTimerDelay;

public class FIPARequestResponder extends AbstractResponder {

	private final Map<IMessage, IGoal> addedGoals = new HashMap<>();

	@OnMessageReceived
	public void onMessage(AclMessage message) {
		if (isNotMyMessage(message)) {
>>>>>>> e9ddd18f... Implement FIPA protocols
			return;
		}
		if (!filter.match(message.getSender())) {
			reply(message, REFUSE);
			return;
		}
		switch (message.getPerformative()) {
		case REQUEST:
			String lang = message.getLanguage();
			IGoalParser parser = getGoalParser(lang);
			if (parser == null) {
				reply(message, NOT_UNDERSTOOD, "Unknown language [" + lang + "]");
				return;
			}
			try {
<<<<<<< HEAD
				OWLIndividualAxiom goal = parser.parse(message.getContent());
				goalBase.add(goal);
				goals.put(message, goal);
				reply(message, AGREE);
				return;
			} catch (Exception e) {
				reply(message, NOT_UNDERSTOOD, "Exception was thrown " + e.getClass() + " " + e.getMessage());
				return;
			}
		case NOT_UNDERSTOOD:
		case CANCEL:
			OWLIndividualAxiom goal = goals.get(message);
			if (goal != null) {
				goalBase.remove(goal);
=======
				IGoal goal = parser.parse(message.getContent());
				goalBase.addGoal(goal);
				addedGoals.put(message, goal);
				reply(message, AGREE);
			} catch (Exception e) {
				reply(message, NOT_UNDERSTOOD, "Exception was thrown " + e.getClass() + " " + e.getMessage());
			}
			return;
		case NOT_UNDERSTOOD:
		case CANCEL:
			IGoal goal = addedGoals.get(message);
			if (goal != null) {
				goalBase.removeGoal(goal);
>>>>>>> e9ddd18f... Implement FIPA protocols
			}
			return;
		}
	}
<<<<<<< HEAD

	@PreDestroy
	public void onDestroy() {
		goals.forEach((message, goal) -> {
			goalBase.remove(goal);
			reply(message, FAILURE, "Destroying role.. Bye..");
		});
	}

	public void onGoalSuccess(IGoal goal) {
		IMessage request = goals.inverse().get(goal);
		if (request != null) {
			reply(request, INFORM, "Goal success");
		}
	}

	public void onGoalFailed(IGoal goal) {
		IMessage request = goals.inverse().get(goal);
		if (request != null) {
			reply(request, FAILURE, "Goal failed");
		}
=======

	@PreDestroy
	public void onDestroy() {
		addedGoals.forEach((message, goal) -> {
			goalBase.removeGoal(goal);
			reply(message, FAILURE, "Destroing role.. Bye..");
		});
	}

	@OnTimerDelay(value = 2, unit = TimeUnit.SECONDS)
	public void onGoalSuccess() {
		IMessage message = addedGoals.keySet().iterator().next();
		reply(message, INFORM);
	}

	public void onGoalFailed(IGoal goal) {

	}

	private boolean isNotMyMessage(AclMessage message) {
		return !message.checkProtocol(FIPA_REQUEST);
>>>>>>> e9ddd18f... Implement FIPA protocols
	}

	private boolean notMyMessage(AclMessage message) {
		return !message.checkProtocol(FIPA_REQUEST);
	}

}
