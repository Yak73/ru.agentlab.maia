package ru.agentlab.maia.execution.scheduler.sequence.test

import java.util.ArrayList
import java.util.Random
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Spy
import org.mockito.runners.MockitoJUnitRunner
import ru.agentlab.maia.execution.scheduler.sequence.SequenceContextScheduler
import ru.agentlab.maia.execution.tree.IExecutionNode
import ru.agentlab.maia.execution.tree.IExecutionScheduler

import static org.hamcrest.Matchers.*
import static org.junit.Assert.*
import static org.mockito.Mockito.*

@RunWith(MockitoJUnitRunner)
class SequenceSchedulerRemoveChildTests {

	val rnd = new Random

	extension SequenceSchedulerTestsExtension = new SequenceSchedulerTestsExtension

	@Spy
	IExecutionScheduler scheduler = new SequenceContextScheduler

	@Test
	def void silenceOnUnknownChild() {
		val size = 10
		val childs = getFakeChilds(size)
		when(scheduler.childs).thenReturn(childs)
		assertThat(scheduler.childs, iterableWithSize(size))

		scheduler.removeChild(mock(IExecutionNode))

		assertThat(scheduler.childs, iterableWithSize(size))
		assertThat(scheduler.childs, contains(childs.toArray))
	}
	
	@Test
	def void silenceOnNullParameter() {
		val size = 10
		val childs = getFakeChilds(size)
		when(scheduler.childs).thenReturn(childs)
		assertThat(scheduler.childs, iterableWithSize(size))

		scheduler.removeChild(null)

		assertThat(scheduler.childs, iterableWithSize(size))
		assertThat(scheduler.childs, contains(childs.toArray))
	}

	@Test
	def void decreaseQueueSize() {
		val size = 10
		val childs = getFakeChilds(size)
		when(scheduler.childs).thenReturn(childs)
		assertThat(scheduler.childs, iterableWithSize(size))

		scheduler.removeChild(childs.get(rnd.nextInt(childs.size)))

		assertThat(scheduler.childs, iterableWithSize(size - 1))
	}

	@Test
	def void clearCurrenNodeWhenLast() {
		val child = mock(IExecutionNode)
		val childs = new ArrayList<IExecutionNode> => [
			add(child)
		]
		when(scheduler.childs).thenReturn(childs)
		assertThat(scheduler.childs, iterableWithSize(1))
		scheduler.currentChild = child

		scheduler.removeChild(child)

		assertThat(scheduler.currentChild, nullValue)
	}

	@Test
	def void removeFromQueue() {
		val size = 10
		val childs = getFakeChilds(size)
		when(scheduler.childs).thenReturn(childs)
		val toRemove = childs.get(rnd.nextInt(childs.size))
		assertThat(toRemove, isIn(scheduler.childs))

		scheduler.removeChild(toRemove)

		assertThat(toRemove, not(isIn(scheduler.childs)))
	}

}