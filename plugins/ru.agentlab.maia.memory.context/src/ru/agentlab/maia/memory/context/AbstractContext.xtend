package ru.agentlab.maia.memory.context

import java.util.Collection
import java.util.Collections
import java.util.HashSet
import java.util.UUID
import javax.inject.Provider
import org.eclipse.xtend.lib.annotations.Accessors
import ru.agentlab.maia.memory.IMaiaContext
import ru.agentlab.maia.memory.exception.MaiaContextKeyNotFound

/**
 * <p>
 * Abstract {@link IMaiaContext} implementation.
 * </p>
 * <p>Implementation guarantee that:
 * </p>
 * <ul>
 * <li>Context can be in hierarchy (have parent and childs);</li>
 * <li>Context will have unique UUID;</li>
 * <li>Context redirect service searching to parent if can't find it;</li>
 * <li>Context disable <code>null</code> keys for storing services;</li>
 * </ul>
 * 
 * @author <a href='shishkindimon@gmail.com'>Shishkin Dmitriy</a> - Initial contribution.
 */
abstract class AbstractContext implements IMaiaContext {

	@Accessors
	val String uuid = UUID.randomUUID.toString

	@Accessors
	var volatile IMaiaContext parent

	@Accessors
	val Collection<IMaiaContext> childs = Collections.synchronizedSet(new HashSet)

	override getService(String key) throws MaiaContextKeyNotFound {
		if (key == null) {
			throw new IllegalArgumentException("Key must be not null")
		}
		try {
			val value = getInternal(key)
			if (value instanceof Provider<?>) {
				return value.get
			} else {
				return value
			}
		} catch (MaiaContextKeyNotFound e) {
			val p = parent
			if (p != null) {
				return p.getService(key)
			} else {
				throw new MaiaContextKeyNotFound(
					'''Service for key [«key»] did not found in context [«this.toString»] and all their parents'''
				)
			}
		}
	}

	override <T> getService(Class<T> key) throws MaiaContextKeyNotFound {
		if (key == null) {
			throw new IllegalArgumentException("Key must be not null")
		}
		try {
			val value = getInternal(key)
			if (value instanceof Provider<?>) {
				return value.get as T
			} else {
				return value as T
			}
		} catch (MaiaContextKeyNotFound e) {
			val p = parent
			if (p != null) {
				return p.getService(key)
			} else {
				throw new MaiaContextKeyNotFound(
					'''Service for key [«key»] did not found in context [«this.toString»] and all their parents'''
				)
			}
		}
	}

	override getServiceLocal(String key) throws MaiaContextKeyNotFound {
		if (key == null) {
			throw new IllegalArgumentException("Key must be not null")
		}
		val value = getInternal(key)
		if (value instanceof Provider<?>) {
			return value.get
		} else {
			return value
		}
	}

	override <T> getServiceLocal(Class<T> key) throws MaiaContextKeyNotFound {
		if (key == null) {
			throw new IllegalArgumentException("Key must be not null")
		}
		val value = getInternal(key)
		if (value instanceof Provider<?>) {
			return value.get as T
		} else {
			return value as T
		}
	}

	override getProvider(String key) throws MaiaContextKeyNotFound {
		if (key == null) {
			throw new IllegalArgumentException("Key must be not null")
		}
		try {
			val value = getInternal(key)
			if (value instanceof Provider<?>) {
				return value as Provider<?>
			} else {
				return null
			}
		} catch (MaiaContextKeyNotFound e) {
			val p = parent
			if (p != null) {
				return p.getProvider(key)
			} else {
				throw new MaiaContextKeyNotFound(
					'''Provider for key [«key»] did not found in context [«this.toString»] and all their parents'''
				)
			}
		}
	}

	override <T> getProvider(Class<T> key) throws MaiaContextKeyNotFound {
		if (key == null) {
			throw new IllegalArgumentException("Key must be not null")
		}
		try {
			val value = getInternal(key)
			if (value instanceof Provider<?>) {
				return value as Provider<T>
			} else {
				return null
			}
		} catch (MaiaContextKeyNotFound e) {
			val p = parent
			if (p != null) {
				return p.getProvider(key)
			} else {
				throw new MaiaContextKeyNotFound(
					'''Provider for key [«key»] did not found in context [«this.toString»] and all their parents'''
				)
			}
		}
	}

	override getProviderLocal(String key) throws MaiaContextKeyNotFound {
		if (key == null) {
			throw new IllegalArgumentException("Key must be not null")
		}
		val value = getInternal(key)
		if (value instanceof Provider<?>) {
			return value as Provider<?>
		} else {
			return null
		}
	}

	override <T> getProviderLocal(Class<T> key) throws MaiaContextKeyNotFound {
		if (key == null) {
			throw new IllegalArgumentException("Key must be not null")
		}
		val value = getInternal(key)
		if (value instanceof Provider<?>) {
			return value as Provider<T>
		} else {
			return null
		}
	}

	override putService(String key, Object value) {
		if (key == null) {
			throw new IllegalArgumentException("Key must be not null")
		}
		putInternal(key, value)
	}

	override <T> putService(Class<T> key, T value) {
		if (key == null) {
			throw new IllegalArgumentException("Key must be not null")
		}
		putInternal(key, value)
	}

	override putProvider(String key, Provider<?> provider) {
		if (key == null) {
			throw new IllegalArgumentException("Key must be not null")
		}
		putInternal(key, provider)
	}

	override <T> putProvider(Class<T> key, Provider<T> provider) {
		if (key == null) {
			throw new IllegalArgumentException("Key must be not null")
		}
		putInternal(key, provider)
	}

	override remove(String key) {
		if (key == null) {
			throw new IllegalArgumentException("Key must be not null")
		}
		removeInternal(key)
	}

	override remove(Class<?> key) {
		if (key == null) {
			throw new IllegalArgumentException("Key must be not null")
		}
		removeInternal(key)
	}

	override addChild(IMaiaContext child) {
		childs += child
	}

	override removeChild(IMaiaContext child) {
		childs -= child
	}

	override void setParent(IMaiaContext newParent) {
		parent?.removeChild(this)
		parent = newParent
		parent.addChild(this)
	}

	def protected Object getInternal(String key) throws MaiaContextKeyNotFound

	def protected Object getInternal(Class<?> key) throws MaiaContextKeyNotFound

	def protected void putInternal(String key, Object value)

	def protected void putInternal(Class<?> key, Object value)

	def protected Object removeInternal(String key)

	def protected Object removeInternal(Class<?> key)

}