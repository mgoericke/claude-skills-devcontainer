/**
 * Service für Warenkorb-Geschäftslogik.
 *
 * <p>BCE-Architektur: Control-Schicht
 *
 * @author Development Team
 * @author Co-Author: Claude (claude-sonnet-4-6, Anthropic) – generiert via frontend-skill
 */
package de.javamark.control;

import de.javamark.entity.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;
import java.util.UUID;

@Service
@Transactional
public class CartService {

    private final CartRepository cartRepository;
    private final CartItemRepository cartItemRepository;
    private final ProductRepository productRepository;

    public CartService(CartRepository cartRepository, CartItemRepository cartItemRepository, ProductRepository productRepository) {
        this.cartRepository = cartRepository;
        this.cartItemRepository = cartItemRepository;
        this.productRepository = productRepository;
    }

    public Cart createCart() {
        return cartRepository.save(Cart.builder().build());
    }

    @Transactional(readOnly = true)
    public Optional<Cart> findById(UUID cartId) {
        return cartRepository.findById(cartId);
    }

    public Cart addItem(UUID cartId, UUID productId, int quantity) {
        Cart cart = cartRepository.findById(cartId)
                .orElseThrow(() -> new IllegalArgumentException("Cart not found: " + cartId));
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Product not found: " + productId));

        Optional<CartItem> existing = cartItemRepository.findByCartIdAndProductId(cartId, productId);
        if (existing.isPresent()) {
            CartItem item = existing.get();
            item.setQuantity(item.getQuantity() + quantity);
            cartItemRepository.save(item);
        } else {
            CartItem item = CartItem.builder()
                    .cart(cart)
                    .product(product)
                    .quantity(quantity)
                    .build();
            cart.getItems().add(item);
        }

        return cartRepository.save(cart);
    }

    public Cart updateItemQuantity(UUID cartId, UUID itemId, int quantity) {
        Cart cart = cartRepository.findById(cartId)
                .orElseThrow(() -> new IllegalArgumentException("Cart not found: " + cartId));
        CartItem item = cartItemRepository.findById(itemId)
                .orElseThrow(() -> new IllegalArgumentException("CartItem not found: " + itemId));

        if (quantity <= 0) {
            cart.getItems().remove(item);
            cartItemRepository.delete(item);
        } else {
            item.setQuantity(quantity);
            cartItemRepository.save(item);
        }

        return cartRepository.save(cart);
    }

    public Cart removeItem(UUID cartId, UUID itemId) {
        Cart cart = cartRepository.findById(cartId)
                .orElseThrow(() -> new IllegalArgumentException("Cart not found: " + cartId));
        CartItem item = cartItemRepository.findById(itemId)
                .orElseThrow(() -> new IllegalArgumentException("CartItem not found: " + itemId));

        cart.getItems().remove(item);
        cartItemRepository.delete(item);
        return cartRepository.save(cart);
    }

    public void clearCart(UUID cartId) {
        Cart cart = cartRepository.findById(cartId)
                .orElseThrow(() -> new IllegalArgumentException("Cart not found: " + cartId));
        cart.getItems().clear();
        cartRepository.save(cart);
    }
}
