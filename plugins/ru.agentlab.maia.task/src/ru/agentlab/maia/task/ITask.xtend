package ru.agentlab.maia.task

interface ITask {

//	def String getUuid()
	
	def String getLabel()
	
	def void setLabel(String newLabel)

	/**
	 * <p>Invoke one step of execution of the task.</p>
	 */
	def void execute()

	/**
	 * <p>Retrieve task parent.</p>
	 * 
	 * @return 					task parent.
	 */
	def ITaskScheduler getParent()

	/**
	 * <p>Change task parent. Automatically register task as subtask of parent.</p>
	 * 
	 * @param parent			parent task.
	 */
	def void setParent(ITaskScheduler parent)

	/**
	 * <p>Retrieve task state.</p>
	 * 
	 * @return 					task state.
	 */
	def TaskState getState()

	/**
	 * <p>Change task state.</p>
	 * 
	 * @param parent			new task state.
	 * @return 					previous task state.
	 */
	def TaskState setState(TaskState newState)

	/**
	 * <p>Retrieve all task inputs.</p>
	 * 
	 * @return 					collection of task inputs or
	 * 							{@code null} if task have no inputs.
	 */
	def Iterable<ITaskParameter<?>> getInputs()

	/**
	 * <p>Retrieve all task outputs.</p>
	 * 
	 * @return 					collection of task outputs or
	 * 							{@code null} if task have no outputs.
	 */
	def Iterable<ITaskParameter<?>> getOutputs()

	/**
	 * <p>Add specified parameter as input to task.</p>
	 * 
	 * @param parameter			parameter to be added.
	 */
	def void addInput(ITaskParameter<?> parameter)

	/**
	 * <p>Add specified parameter as output to task.</p>
	 * 
	 * @param parameter			parameter to be added.
	 */
	def void addOutput(ITaskParameter<?> parameter)

	/**
	 * <p>Remove specified parameter from task inputs.</p>
	 * 
	 * @param parameter			parameter to be removed.
	 */
	def void removeInput(ITaskParameter<?> parameter)

	/**
	 * <p>Remove specified parameter from task outputs.</p>
	 * 
	 * @param parameter			parameter to be removed.
	 */
	def void removeOutput(ITaskParameter<?> parameter)

	/**
	 * <p>Remove all parameters from task inputs.</p>
	 */
	def void clearInputs()

	/**
	 * <p>Remove all parameters from task outputs.</p>
	 */
	def void clearOutputs()
	
	def Iterable<ITaskException> getExceptions()
	
	def void addException(ITaskException exception)
	
	def void removeException(ITaskException exception)
	
	def void clearExceptions()

	/**
	 * <p>Reset task to initial state.</p>
	 */
	def void reset()

}