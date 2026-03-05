/**
 * JPA-Repository für CartItem.
 *
 * @author Development Team
 * @author Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via frontend-skill
 */
package de.javamark.entity;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface CartItemRepository extends JpaRepository<CartItem, UUID> {

    Optional<CartItem> findByCartIdAndProductId(UUID cartId, UUID productId);
}
