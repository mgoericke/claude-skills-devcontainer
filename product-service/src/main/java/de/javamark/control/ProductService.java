/**
 * Service für Product-Geschäftslogik.
 *
 * <p>BCE-Architektur: Control-Schicht<br>
 * Transaktionsgrenzen werden hier definiert. Lese-Operationen sind
 * als {@code readOnly} markiert für bessere Performance.
 *
 * @author Development Team
 * @author Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via java-scaffold-skill
 */
package de.javamark.control;

import de.javamark.entity.Product;
import de.javamark.entity.ProductRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@Transactional
public class ProductService {

    private final ProductRepository productRepository;

    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @Transactional(readOnly = true)
    public List<Product> findAll() {
        return productRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Optional<Product> findById(UUID id) {
        return productRepository.findById(id);
    }

    public Product save(Product entity) {
        return productRepository.save(entity);
    }

    public Optional<Product> update(UUID id, Product updated) {
        return productRepository.findById(id)
                .map(existing -> {
                    existing.setName(updated.getName());
                    existing.setDescription(updated.getDescription());
                    existing.setPrice(updated.getPrice());
                    return productRepository.save(existing);
                });
    }

    public void deleteById(UUID id) {
        productRepository.deleteById(id);
    }
}
