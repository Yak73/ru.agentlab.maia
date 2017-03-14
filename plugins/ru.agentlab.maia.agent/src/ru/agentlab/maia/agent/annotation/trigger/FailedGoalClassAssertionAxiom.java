package ru.agentlab.maia.agent.annotation.trigger;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import ru.agentlab.maia.agent.annotation.converter.OWLClassAssertionAxiomTemplateConverter;
import ru.agentlab.maia.agent.converter.PlanEventFilterConverter;
import ru.agentlab.maia.agent.converter.PlanEventType;
import ru.agentlab.maia.agent.event.FailedGoalClassAssertionAxiomEvent;

@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
@PlanEventType(FailedGoalClassAssertionAxiomEvent.class)
@PlanEventFilterConverter(OWLClassAssertionAxiomTemplateConverter.class)
public @interface FailedGoalClassAssertionAxiom {

	String[] value() default { "?$1", "?$2" };

}