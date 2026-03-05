/**
 * JPA-Repository für Product.
 *
 * <p>BCE-Architektur: Entity-Schicht<br>
 * Spring Data JPA generiert die Standard-Implementierung automatisch.
 *
 * @author Development Team
 * @author Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via java-scaffold-skill
 */
package de.javamark.entity;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface ProductRepository extends JpaRepository<Product, UUID> {
}
